defmodule AfbWeb.DataSetController do
  use AfbWeb, :controller

  require Logger

  alias Afb.Repo

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
    do_show Repo.get_by(DataSet, slug: slug), conn
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

  def new(conn, _params) do
    changeset = DataSet.new()
    action = data_set_path(conn, :create)

    render conn, "create.html",
      changeset: changeset,
      action: action
  end

  def create(conn, %{"data_set" => params}), do: do_create DataSet.create(params), conn

  defp do_create({:ok, ds}, conn) do
    conn
    |> put_flash(:success, "Created new data set #{inspect(ds.name)}")
    |> redirect(to: data_set_path(conn, :show, ds))
  end

  defp do_create({:error, changeset}, conn) do
    action = data_set_path(conn, :create)

    conn
    |> put_status(:bad_request)
    |> put_flash(:error, "Please fix form errors below.")
    |> render("create.html",
      changeset: changeset,
      action: action
    )
  end

  def edit(conn, %{"id" => slug}), do: do_edit DataSet.get(slug), conn

  defp do_edit(nil, conn), do: do_404 conn

  defp do_edit(ds, conn) do
    changeset = DataSet.edit(ds)
    action = data_set_path(conn, :update, ds)
    render conn, "update.html",
      data_set: ds,
      changeset: changeset,
      action: action
  end

  def update(conn, %{"id" => slug, "data_set" => params}), do: do_update DataSet.get(slug), conn, params

  defp do_update(nil, conn, _), do: do_404 conn

  defp do_update(ds, conn, params), do: do_update_action DataSet.update(ds, params), conn, ds

  defp do_update_action({:ok, ds}, conn, _) do
    conn
    |> put_flash(:success, "Updated data set #{inspect(ds.name)}")
    |> redirect(to: data_set_path(conn, :show, ds))
  end

  defp do_update_action({:error, changeset}, conn, ds) do
    action = data_set_path(conn, :update, ds)
    conn
    |> put_status(:bad_request)
    |> put_flash(:error, "Please fix form errors below.")
    |> render("update.html",
      data_set: ds,
      changeset: changeset,
      action: action
    )
  end

  def delete(conn, %{"id" => slug}), do: do_delete DataSet.get(slug), conn

  defp do_delete(nil, conn), do: do_404 conn

  defp do_delete(ds, conn), do: do_delete_action DataSet.delete(ds), conn

  defp do_delete_action({:ok, ds}, conn) do
    conn
    |> put_flash(:success, "Deleted data set #{ds.name}")
    |> redirect(to: data_set_path(conn, :index))
  end

  defp do_delete_action({:error, changeset}, conn) do
    for e <- changeset.errors, do: Logger.error(e)
    conn
    |> put_flash(:error, "Something went wrong.")
    |> redirect(to: data_set_path(conn, :index))
  end

  def process(conn, %{"id" => slug}), do: do_process DataSet.get(slug), conn

  defp do_process(nil, conn), do: do_404 conn

  defp do_process(ds, conn) do
    Task.async fn -> Afb.process_s3_archive(ds) end
    Plug.Conn.resp(conn, :ok, "")
  end

  def download_nodes_csv(conn, %{"id" => slug}), do: do_download_nodes_csv DataSet.get(slug), conn

  defp do_download_nodes_csv(nil, conn), do: do_404 conn

  defp do_download_nodes_csv(ds, conn) do
    conn
    |> put_resp_header("content-disposition", "attachment; filename=nodes.csv")
    |> put_resp_content_type("text/csv; charset=UTF-8")
    |> send_chunked(:ok)
    |> chunk(ds.nodes)
  end

  def download_sensors_csv(conn, %{"id" => slug}), do: do_download_sensors_csv DataSet.get(slug), conn

  defp do_download_sensors_csv(nil, conn), do: do_404 conn

  defp do_download_sensors_csv(ds, conn) do
    conn
    |> put_resp_header("content-disposition", "attachment; filename=sensors.csv")
    |> put_resp_content_type("text/csv; charset=UTF-8")
    |> send_chunked(:ok)
    |> chunk(ds.sensors)
  end

  def download_readme(conn, %{"id" => slug}), do: do_download_readme DataSet.get(slug), conn

  defp do_download_readme(nil, conn), do: do_404 conn

  defp do_download_readme(ds, conn) do
    conn
    |> put_resp_header("content-disposition", "attachment; filename=README.md")
    |> put_resp_content_type("text/markdown; charset=UTF-8")
    |> send_chunked(:ok)
    |> chunk(ds.readme)
  end
end
