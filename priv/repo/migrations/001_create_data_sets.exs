defmodule Afb.Repo.Migrations.CreateDataSets do
  use Ecto.Migration

  def change do
    create table(:data_sets) do
      add :name, :text
      add :slug, :text
      add :source_url, :text
      add :data_start_date, :timestamp
      add :data_end_date, :timestamp
      add :latest_creation_date, :timestamp
      add :latest_data_format_version, :text
      add :readme, :text
      add :nodes, :text
      add :sensors, :text
      timestamps()
    end

    create unique_index(:data_sets, [:name])

    create unique_index(:data_sets, [:slug])

    create unique_index(:data_sets, [:source_url])
  end
end
