defmodule AfbWeb.AuthController do
  use AfbWeb, :controller

  alias Afb.Auth.{
    Guardian,
    User
  }

  def index(conn, _), do: render conn, "index.html"

  def login(conn, %{"email" => email, "password" => password}) do
    user = User.get(email)
    case User.authenticate(user, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:success, "Well how dee.")
        |> redirect(to: data_set_path(conn, :index))

      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> render("index.html")
    end
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:success, "Y'all come on back real soon.")
    |> redirect(to: data_set_path(conn, :index))
  end
end
