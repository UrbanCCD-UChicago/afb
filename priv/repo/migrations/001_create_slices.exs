defmodule Afb.Repo.Migrations.CreateSlices do
  use Ecto.Migration

  def change do
    create table(:slices) do
      add :bucket,        :text,      null: false
      add :key,           :text,      null: false
      add :last_modified, :timestamp
      add :expiry_date,   :timestamp
      add :size,          :integer
      add :data_set_id,   references(:data_sets, on_delete: :delete_all)
    end

    create unique_index(:slices, [:bucket, :key], name: :slices_bucket_key)
  end
end
