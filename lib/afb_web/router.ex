defmodule AfbWeb.Router do
  use AfbWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", AfbWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/community", PageController, :community
    get "/sensor-status", PageController, :sensor_status

    resources "/data-sets", DataSetController, only: [:index, :show]
    get "/data-sets/:id/process", DataSetController, :process
  end
end
