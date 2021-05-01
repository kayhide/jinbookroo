defmodule JinbookrooWeb.PersonController do
  use JinbookrooWeb, :controller

  alias Jinbookroo.Books
  alias Jinbookroo.Books.Person

  action_fallback JinbookrooWeb.FallbackController

  def index(conn, _params) do
    persons = Books.list_persons()
    render(conn, "index.json", persons: persons)
  end

  def create(conn, person_params) do
    with {:ok, %Person{} = person} <- Books.create_person(person_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.person_path(conn, :show, person))
      |> render("show.json", person: person)
    end
  end

  def show(conn, %{"id" => id}) do
    person = Books.get_person!(id)
    render(conn, "show.json", person: person)
  end

  def update(conn, %{"id" => id} = person_params) do
    person = Books.get_person!(id)

    with {:ok, %Person{} = person} <- Books.update_person(person, person_params) do
      render(conn, "show.json", person: person)
    end
  end

  def delete(conn, %{"id" => id}) do
    person = Books.get_person!(id)

    with {:ok, %Person{}} <- Books.delete_person(person) do
      send_resp(conn, :no_content, "")
    end
  end
end
