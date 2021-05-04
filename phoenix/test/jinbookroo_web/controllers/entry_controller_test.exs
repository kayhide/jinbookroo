defmodule JinbookrooWeb.EntryControllerTest do
  use JinbookrooWeb.ConnCase

  alias Jinbookroo.Books
  alias Jinbookroo.Books.Entry
  alias Jinbookroo.Books.Person

  @create_attrs %{
    ammount: 20,
    description: "some description",
    side: :debit,
    subject: "some subject",
  }
  @update_attrs %{
    ammount: 40,
    description: "some updated description",
    side: :credit,
    subject: "some updated subject",
  }
  @invalid_attrs %{description: nil, side: nil, subject: nil}

  def fixture(:person) do
    {:ok, person} = Books.create_person(%{name: "Person"})
    person
  end

  def fixture(:entry) do
    person = fixture(:person)
    {:ok, entry} = Books.create_entry(Map.merge(@create_attrs, %{person_id: person.id}))
    entry
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all entries", %{conn: conn} do
      conn = get(conn, Routes.entry_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create entry" do
    test "renders entry when data is valid", %{conn: conn} do
      conn = post(conn, Routes.entry_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.entry_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some description",
               "side" => "debit",
               "subject" => "some subject"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.entry_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "associates person", %{conn: conn} do
      %Person{id: person_id} = fixture(:person)
      conn = post(conn, Routes.entry_path(conn, :create), Map.merge(@create_attrs, %{person_id: person_id}))
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.entry_path(conn, :show, id))
      assert %{"person_id" => ^person_id} = json_response(conn, 200)
    end
  end

  describe "update entry" do
    setup [:create_entry]

    test "renders entry when data is valid", %{conn: conn, entry: %Entry{id: id} = entry} do
      conn = put(conn, Routes.entry_path(conn, :update, entry), @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.entry_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "side" => "credit",
               "subject" => "some updated subject"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, entry: entry} do
      conn = put(conn, Routes.entry_path(conn, :update, entry), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete entry" do
    setup [:create_entry]

    test "deletes chosen entry", %{conn: conn, entry: entry} do
      conn = delete(conn, Routes.entry_path(conn, :delete, entry))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.entry_path(conn, :show, entry))
      end
    end
  end

  defp create_entry(_) do
    entry = fixture(:entry)
    %{entry: entry}
  end
end
