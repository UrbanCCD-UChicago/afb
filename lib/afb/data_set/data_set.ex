defmodule Afb.DataSet.DataSet do
  use Ecto.Schema

  @derive {Phoenix.Param, key: :slug}
  schema "data_sets" do
    # basic info added via admin
    field :name, :string
    field :slug, :string
    field :source_url, :string

    # info pulled from provenance.csv
    field :data_start_date, :naive_datetime
    field :data_end_date, :naive_datetime
    field :latest_creation_date, :naive_datetime
    field :latest_data_format_version, :string

    # tarball info
    field :readme, :string
    field :nodes, :string
    field :sensors, :string

    timestamps()
  end

  import Ecto.Changeset

  def changeset(ds, params) do
    ds
    |> cast(params, [
      :name, :slug, :source_url, :data_start_date, :data_end_date,
      :latest_creation_date, :latest_data_format_version,
      :readme, :nodes, :sensors,
    ])
    |> validate_required([:name, :slug, :source_url])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
    |> unique_constraint(:source_url)
  end

  import Ecto.Query

  alias Afb.Repo

  alias Afb.DataSet.DataSet

  def list, do: Repo.all(DataSet |> order_by([d], d.name))

  def get(identifier) do
    case Regex.match?(~r/^\d+$/, identifier) do
      true -> Repo.get_by(DataSet, id: identifier)
      false -> Repo.get_by(DataSet, slug: identifier)
    end
  end

  def new, do: changeset(%DataSet{}, %{})

  def create(params), do: changeset(%DataSet{}, params) |> Repo.insert()

  def edit(ds), do: changeset(ds, %{})

  def update(ds, params), do: changeset(ds, params) |> Repo.update()

  def delete(ds), do: Repo.delete(ds)
end
