defmodule AfbWeb.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      import AfbWeb.Router.Helpers
      @endpoint AfbWeb.Endpoint
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Afb.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Afb.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

end
