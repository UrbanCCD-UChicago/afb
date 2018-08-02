defmodule Afb do
  require Logger

  import Ecto.Query

  alias Afb.Repo

  alias Afb.DataSet.{
    DataSet,
    Slice
  }

  @bucket "aot-tarballs"

  def process_bucket(%DataSet{} = ds) do
    list_s3(ds.slug)
    |> Enum.map(& parse_s3_object(&1, ds))
  end

  defp list_s3(slug) do
    Logger.info("Scanning S3 for prefix #{slug}")

    %{body: %{contents: objects}} =
      ExAws.S3.list_objects(@bucket, prefix: slug)
      |> ExAws.request!()

    objects
  end

  defp parse_s3_object(%{key: key, last_modified: mod, size: size}, ds) do
    Logger.info("Parsing S3 object #{key}")

    %{headers: headers} =
      ExAws.S3.head_object(@bucket, key)
      |> ExAws.request!()

    exp_header =
      Enum.filter(headers, fn {key, _} -> key == "x-amz-expiration" end)
      |> List.first()

    case exp_header do
      nil ->
        :ok

      {_, parse_me} ->
        # because amazon is so awesome and they totally make every developer's
        # life a dream by not instituting and then doubling down on totally
        # shitty ideas, their time strings come back as, and i'm not kidding,
        # "expiry-date=\"Thu, 09 Aug 2018 00:00:00 GMT\", rule-id=\"daily-ttl\""
        expiry_date =
          Regex.scan(~r/\d+ \w+ \d{4} \d{2}\:\d{2}\:\d{2} \w{3}/, parse_me)
          |> List.flatten()
          |> List.first()
          |> Timex.parse!("%d %b %Y %H:%M:%S %Z", :strftime)
          |> Timex.Timezone.convert("Etc/UTC")
          |> Timex.to_naive_datetime()

        Slice.create(ds, %{
          bucket: @bucket,
          key: key,
          last_modified: mod,
          size: size,
          expiry_date: expiry_date
        })
    end

    :ok
  end

  def process_archive(%DataSet{} = ds, key) do
    tempfile = download_tarball_from_s3(key)
    dirname = tar_xf_tempfile(tempfile)

    readme = read_readme(dirname)
    nodes = read_nodes(dirname)
    sensors = read_sensors(dirname)

    prov = read_provenance(dirname)
    src_url = prov["url"]
    data_starts = prov["data_start_date"] |> parse_date()
    data_ends = prov["data_end_date"] |> parse_date()
    data_created = prov["creation_date"] |> parse_date()

    {:ok, _} = DataSet.update(ds, %{
      readme: readme,
      nodes: nodes,
      sensors: sensors,
      source_url: src_url,
      data_start_date: data_starts,
      data_end_date: data_ends,
      latest_creation_date: data_created
    })
  end

  defp parse_date(string), do: Timex.parse!(string, "%Y/%m/%d %H:%M:%S", :strftime)

  defp download_tarball_from_s3(tarball_name) do
    Logger.info("Downloading tarball from S3...")

    tempfile = "/tmp/#{tarball_name}"
    Logger.debug("Tarball tempfile name is #{inspect(tempfile)}")

    Logger.debug("Starting tarball download")
    {:ok, _} =
      ExAws.S3.download_file(@bucket, tarball_name, tempfile)
      |> ExAws.request()
    Logger.info("Download complete")

    tempfile
  end

  defp tar_xf_tempfile(tempfile) do
    Logger.info("Decompressing tarball")

    Logger.debug("Getting output of tarball")
    {files, 0} = System.cmd("tar", ["tf", tempfile])
    dirname =
      files
      |> String.split("\n")
      |> List.first()
    dirname = "/tmp/#{dirname}"
    Logger.debug("Main decompression output dir will be #{inspect(dirname)}")

    {"", 0} = System.cmd("tar", ["-xf", tempfile, "-C", "/tmp"])
    Logger.debug("Decompress complete")

    dirname
  end

  defp read_readme(dirname) do
    Logger.info("Reading README.md")

    "#{dirname}/README.md"
    |> File.read!()
  end

  defp read_provenance(dirname) do
    Logger.info("Reading provenance.csv")

    "#{dirname}/provenance.csv"
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.take(1)
    |> List.first()
  end

  defp read_nodes(dirname) do
    Logger.info("Reading nodes.csv")

    "#{dirname}/nodes.csv"
    |> File.read!()
  end

  defp read_sensors(dirname) do
    Logger.info("Reading sensors.csv")

    "#{dirname}/sensors.csv"
    |> File.read!()
  end

  def purge_old_slices do
    Slice
    |> where([s], s.expiry_date < ^NaiveDateTime.utc_now())
    |> Repo.all()
    |> Enum.map(&Repo.delete/1)
  end
end
