defmodule Afb.DataSet.Slice do
  use Ecto.Schema

  import Ecto.Changeset

  alias Afb.Repo

  alias Afb.DataSet.{
    DataSet,
    Slice
  }

  schema "slices" do
    field :bucket, :string
    field :key, :string
    field :last_modified, :naive_datetime
    field :expiry_date, :naive_datetime
    field :size, :integer
    belongs_to :data_set, Afb.DataSet.DataSet
  end

  @keys [
    :bucket, :key, :last_modified, :expiry_date, :size, :data_set_id
  ]

  def changeset(%{} = params) do
    %Slice{}
    |> cast(params, @keys)
    |> validate_required([:bucket, :key, :data_set_id])
    |> unique_constraint(:slices_bucket_key, name: :slices_bucket_key)
    |> foreign_key_constraint(:data_set_id)
  end

  def create(%DataSet{} = ds, %{} = params) do
    params
    |> Map.merge(%{data_set_id: ds.id})
    |> changeset()
    |> Repo.insert()
  end

  def make_link(%Slice{bucket: bucket, key: key}), do: "https://s3.amazonaws.com/#{bucket}/#{key}"
end
