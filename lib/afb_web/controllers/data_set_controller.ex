defmodule AfbWeb.DataSetController do
  use AfbWeb, :controller

  require Logger

  alias Afb.DataSet.DataSet

  defp do_404(conn) do
    conn
    |> put_status(:not_found)
    |> put_flash(:error, "Could not find #{inspect(conn.params["slug"])}")
    |> redirect(to: data_set_path(conn, :index))
  end

  def index(conn, _params) do
    data_sets = DataSet.list()

    render conn, "index.html",
      data_sets: data_sets
  end

  def show(conn, %{"id" => slug}) do
    do_show DataSet.get(slug), conn
  end

  defp do_show(nil, conn), do: do_404 conn

  defp do_show(ds, conn) do
    {node_headers, node_body} =
      case ds.nodes do
        nil ->
          {[], []}

        _ ->
          [headers | body] = String.split(ds.nodes, "\n")
          headers = String.split(headers, ",")
          body = Enum.map(body, & String.split(&1, ","))
          {headers, body}
      end

    {sensor_headers, sensor_body} =
      case ds.sensors do
        nil ->
          {[], []}

        _ ->
          [headers | body] = String.split(ds.sensors, "\n")
          headers = String.split(headers, ",")
          body = Enum.map(body, & String.split(&1, ","))
          {headers, body}
      end

    render conn, "show.html",
      data_set: ds,
      node_headers: node_headers,
      node_body: node_body,
      sensor_headers: sensor_headers,
      sensor_body: sensor_body
  end

  def process(conn, %{"id" => slug, "archive" => archive}), do: do_process DataSet.get(slug), conn, archive

  defp do_process(nil, conn, _), do: do_404 conn

  defp do_process(ds, conn, archive) do
    Task.async fn -> Afb.process_archive(ds, archive) end
    Plug.Conn.resp(conn, :ok, "")
  end
end
