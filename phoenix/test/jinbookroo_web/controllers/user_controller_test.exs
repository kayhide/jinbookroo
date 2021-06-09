defmodule JinbookrooWeb.UserControllerTest do
  use JinbookrooWeb.ConnCase

  alias JinbookrooWeb.Auth.Guardian
  alias Jinbookroo.Accounts
  alias Jinbookroo.Accounts.User

  @create_attrs %{
    email: "some email",
    name: "some name"
  }
  @update_attrs %{
    email: "some updated email",
    name: "some updated name"
  }
  @invalid_attrs %{email: nil, name: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
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
    test "lists all users", %{conn: conn, current_user: current_user} do
      conn = get(conn, Routes.user_path(conn, :index))
      current_user_id = current_user.id
      assert [%{"id" => ^current_user_id}] = json_response(conn, 200)
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "email" => "some email",
               "name" => "some name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "name" => "some updated name"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    %{user: user}
  end
end
