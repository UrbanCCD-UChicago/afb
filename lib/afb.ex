defmodule Afb do

  require Logger

  alias Afb.DataSet.DataSet

  @bucket "aot-tarballs"

  def process_s3_archive(data_set) do
    tempfile = download_tarball_from_s3("#{data_set.slug}.metadata.tar")
    dirname = tar_xf_tempfile(tempfile)

    readme = read_readme(dirname)
    nodes = read_nodes(dirname)
    sensors = read_sensors(dirname)

    prov = read_provenance(dirname)
    src_url = prov["url"]
    data_starts = prov["data_start_date"] |> parse_date()
    data_ends = prov["data_end_date"] |> parse_date()
    data_created = prov["creation_date"] |> parse_date()
    data_fmt = prov["data_format_version"]

    {:ok, _} = DataSet.update(data_set, %{
      readme: readme,
      nodes: nodes,
      sensors: sensors,
      source_url: src_url,
      data_start_date: data_starts,
      data_end_date: data_ends,
      latest_creation_date: data_created,
      latest_data_format_version: data_fmt,
    })
  end

  defp parse_date(string) do
    Timex.parse!(string, "%Y/%m/%d %H:%M:%S", :strftime)
  end

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

  defp upload_data_csv_to_s3(dirname, data_set_slug) do
    Logger.info("Uploading retagged data csv to S3...")

    existing_name = "#{dirname}/data.csv"
    new_name = "#{dirname}/#{data_set_slug}.24h.csv"
    Logger.debug("Renaming #{inspect(existing_name)} to #{inspect(new_name)}")
    {"", 0} = System.cmd("mv", [existing_name, new_name])
    Logger.debug("Rename complete")

    Logger.info("Gzipping #{inspect(new_name)}")
    {"", 0} = System.cmd("gzip", ["-f", new_name])
    Logger.debug("Gzip complete")

    gzipped = "#{new_name}.gz"
    key =
      gzipped
      |> String.split("/")
      |> List.last()

    Logger.debug("Starting upload. src=#{inspect(gzipped)} bucket=#{inspect(@bucket)} key=#{inspect(key)}")
    {:ok, _} =
      gzipped
      |> ExAws.S3.Upload.stream_file()
      |> ExAws.S3.upload(@bucket, key)
      |> ExAws.request()
    Logger.info("Upload complete")

    :ok
  end
end
