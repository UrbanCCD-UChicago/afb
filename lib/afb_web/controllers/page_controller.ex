defmodule AfbWeb.PageController do
  use AfbWeb, :controller

  def index(conn, _params), do: render conn, "index.html"

  def community(conn, _params), do: render conn, "community.html"

  def sensor_status(conn, _params), do: render conn, "sensor_status.html"
end
