defmodule Afb.Auth.ErrorHandler do
  use AfbWeb, :controller

  def auth_error(conn, _, _) do
    conn
    |> put_status(:not_found)
    |> put_flash(:error, "Could not find that route.")
    |> redirect(to: page_path(conn, :index))
  end
end
