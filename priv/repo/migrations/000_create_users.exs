defmodule Afb.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :text
      add :password_hash, :text
    end

    create unique_index(:users, [:email])
  end
end
