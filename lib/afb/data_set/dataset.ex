defmodule Afb.DataSet.DataSet do
  use Ecto.Schema

  import Ecto.{
    Changeset,
    Query
  }

  alias Afb.Repo

  alias Afb.DataSet.DataSet

  @derive {Phoenix.Param, key: :slug}
  schema "data_sets" do
    # basic info added by an admin
    field :name, :string
    field :slug, :string
    field :mcs_source_url, :string

    # info pulled from provenance.csv
    field :data_start_date, :naive_datetime
    field :data_end_date, :naive_datetime
    field :latest_creation_date, :naive_datetime

    # read out of tarball metadata files
    field :readme, :string
    field :nodes, :string
    field :sensors, :string

    timestamps()

    has_many :slices, Afb.DataSet.Slice
  end

  @keys [
    :name, :slug, :mcs_source_url, :data_start_date, :data_end_date,
    :latest_creation_date, :readme, :nodes, :sensors
  ]

  def changeset(%{} = params), do: changeset(%DataSet{}, params)

  def changeset(%DataSet{} = ds, %{} = params) do
    ds
    |> cast(params, @keys)
    |> validate_required([:name, :slug, :mcs_source_url])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
    |> unique_constraint(:mcs_source_url)
  end

  def create(name, slug, source) do
    changeset(%{name: name, slug: slug, mcs_source_url: source})
    |> Repo.insert()
  end

  def update(%DataSet{} = ds, opts \\ []) do
    params = Enum.into(opts, %{})
    changeset(ds, params)
    |> Repo.update()
  end

  def get(id) do
    make_get(id)
    |> preload(slices: :data_set)
    |> Repo.one()
  end

  defp make_get(id) when is_integer(id), do: from d in DataSet, where: d.id == ^id

  defp make_get(id) when is_bitstring(id) do
    case Regex.match?(~r/^\d+$/, id) do
      true -> from d in DataSet, where: d.id == ^id
      false -> from d in DataSet, where: d.slug == ^id
    end
  end

  def list do
    DataSet
    |> order_by([d], d.name)
    |> Repo.all()
  end

  def daily_slices(%DataSet{} = ds) do
    now = NaiveDateTime.utc_now()

    ds.slices
    |> Enum.filter(& Regex.match?(~r/\.daily\./, &1.key))
    |> Enum.filter(& Timex.compare(now, &1.expiry_date) == -1)
    |> Enum.sort(&(&1.key < &2.key))
  end

  def weekly_slices(%DataSet{} = ds) do
    now = NaiveDateTime.utc_now()

    ds.slices
    |> Enum.filter(& Regex.match?(~r/\.weekly\./, &1.key))
    |> Enum.filter(& Timex.compare(now, &1.expiry_date) == -1)
    |> Enum.sort(&(&1.key < &2.key))
  end

  def monthly_slices(%DataSet{} = ds) do
    now = NaiveDateTime.utc_now()

    ds.slices
    |> Enum.filter(& Regex.match?(~r/\.monthly\./, &1.key))
    |> Enum.filter(& Timex.compare(now, &1.expiry_date) == -1)
    |> Enum.sort(&(&1.key < &2.key))
  end

  def get_recent_url(%DataSet{mcs_source_url: url}),
    do: String.replace(url, ".latest.tar", ".recent.csv")
end
