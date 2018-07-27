defmodule AfbWeb.Router do
  use AfbWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Afb.Auth.AuthPipeline
    plug Afb.Auth.CurrentUserPlug
  end

  pipeline :ensure_authenticated do
    plug Afb.Auth.AuthPipeline
    plug Guardian.Plug.EnsureAuthenticated
    plug Afb.Auth.CurrentUserPlug
  end

  scope "/", AfbWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/community", PageController, :community

    get "/login", AuthController, :index
    post "/login", AuthController, :login
    get "/logout", AuthController, :logout

    resources "/data-sets", DataSetController, only: [
      :index, :show
    ]
    get "/data-sets/:id/process", DataSetController, :process
    get "/data-sets/:id/download/nodes.csv", DataSetController, :download_nodes_csv
    get "/data-sets/:id/download/sensors.csv", DataSetController, :download_sensors_csv
    get "/data-sets/:id/download/README.md", DataSetController, :download_readme
  end

  scope "/", AfbWeb do
    pipe_through [:browser, :ensure_authenticated]

    resources "/data-sets", DataSetController, only: [
      :new, :create, :edit, :update, :delete
    ]
  end
end
