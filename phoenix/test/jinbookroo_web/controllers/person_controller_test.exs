defmodule JinbookrooWeb.PersonControllerTest do
  use JinbookrooWeb.ConnCase

  alias JinbookrooWeb.Auth.Guardian
  alias Jinbookroo.Accounts
  alias Jinbookroo.Books
  alias Jinbookroo.Books.Person

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:person) do
    {:ok, person} = Books.create_person(@create_attrs)
    person
  end

  setup %{conn: conn} do
    {:ok, user} = Accounts.create_user(%{email: "user@jinbookroo.test", name: "User 1"})
    {:ok, token} = Guardian.create_token(user)
    conn = conn
    |> put_req_header("authorization", "Bearer " <> token)
    |> put_req_header("accept", "application/json")
    {:ok, conn: conn, current_user: user}
  end

  describe "index" do
    test "lists all persons", %{conn: conn} do
      conn = get(conn, Routes.person_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create person" do
    test "renders person when data is valid", %{conn: conn} do
      conn = post(conn, Routes.person_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.person_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.person_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update person" do
    setup [:create_person]

    test "renders person when data is valid", %{conn: conn, person: %Person{id: id} = person} do
      conn = put(conn, Routes.person_path(conn, :update, person), @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.person_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, person: person} do
      conn = put(conn, Routes.person_path(conn, :update, person), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete person" do
    setup [:create_person]

    test "deletes chosen person", %{conn: conn, person: person} do
      conn = delete(conn, Routes.person_path(conn, :delete, person))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.person_path(conn, :show, person))
      end
    end
  end

  defp create_person(_) do
    person = fixture(:person)
    %{person: person}
  end
end
