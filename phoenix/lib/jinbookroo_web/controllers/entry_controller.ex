defmodule JinbookrooWeb.EntryController do
  use JinbookrooWeb, :controller

  alias Jinbookroo.Books
  alias Jinbookroo.Books.Entry

  action_fallback JinbookrooWeb.FallbackController

  def index(conn, %{"person_id" => _} = params) do
    entries =
      Books.list_entries(params)
      |> Books.with_deal()
      |> Books.with_person()
    render(conn, "index.json", entries: entries)
  end

  def index(conn, _params) do
    entries = Books.list_entries() |> Books.with_deal() |> Books.with_person()
    render(conn, "index.json", entries: entries)
  end

  def create(conn, entry_params) do
    with {:ok, %Entry{} = entry} <- Books.create_entry(entry_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.entry_path(conn, :show, entry))
      |> render("show.json", entry: entry)
    end
  end

  def show(conn, %{"id" => id}) do
    entry = Books.get_entry!(id)
    render(conn, "show.json", entry: entry)
  end

  def update(conn, %{"id" => id} = entry_params) do
    entry = Books.get_entry!(id)

    with {:ok, %Entry{} = entry} <- Books.update_entry(entry, entry_params) do
      render(conn, "show.json", entry: entry)
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Books.get_entry!(id)

    with {:ok, %Entry{}} <- Books.delete_entry(entry) do
      send_resp(conn, :no_content, "")
    end
  end
end
