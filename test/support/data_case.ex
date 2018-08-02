defmodule Afb.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Afb.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Afb.DataCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Afb.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Afb.Repo, {:shared, self()})
    end

    :ok
  end
end
