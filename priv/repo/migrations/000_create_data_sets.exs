defmodule Afb.Repo.Migrations.CreateDataSets do
  use Ecto.Migration

  def change do
    create table(:data_sets) do
      add :name,                  :text,        null: false
      add :slug,                  :text,        null: false
      add :mcs_source_url,        :text,        null: false
      add :data_start_date,       :timestamp
      add :data_end_date,         :timestamp
      add :latest_creation_date,  :timestamp
      add :readme,                :text
      add :nodes,                 :text
      add :sensors,               :text
      timestamps()
    end

    create unique_index(:data_sets, [:name])

    create unique_index(:data_sets, [:slug])

    create unique_index(:data_sets, [:mcs_source_url])
  end
end
