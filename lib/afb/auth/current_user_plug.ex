defmodule Afb.Auth.CurrentUserPlug do

  alias Afb.Auth.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    Plug.Conn.assign(conn, :current_user, user)
  end
end
