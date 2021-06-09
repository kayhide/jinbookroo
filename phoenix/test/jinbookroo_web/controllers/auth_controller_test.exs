defmodule JinbookrooWeb.AuthControllerTest do
  use JinbookrooWeb.ConnCase

  alias JinbookrooWeb.Auth.Guardian
  alias Jinbookroo.Accounts

  @user_attrs %{
    name: "User 1",
    email: "user-1@jinbookroo.test",
    password: "secret"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@user_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create" do
    test "renders token when data is valid", %{conn: conn} do
      user = fixture(:user)
      conn = post(conn, Routes.auth_path(conn, :create), %{email: user.email, password: @user_attrs.password})
      assert %{"token" => _token} = json_response(conn, 200)
    end

    test "renders errors when data is missing", %{conn: conn} do
      _user = fixture(:user)
      conn = post(conn, Routes.auth_path(conn, :create), %{})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when password is invalid", %{conn: conn} do
      user = fixture(:user)
      conn = post(conn, Routes.auth_path(conn, :create), %{email: user.email, password: "notreally"})
      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders errors when email is not found", %{conn: conn} do
      conn = post(conn, Routes.auth_path(conn, :create), %{email: "not-such-user@jinbookroo.test", password: "notreally"})
      assert json_response(conn, 401)["errors"] != %{}
    end
  end

  describe "index" do
    test "renders no content", %{conn: conn} do
      user = fixture(:user)
      {:ok, token} = Guardian.create_token(user)
      conn = conn
      |> put_req_header("authorization", "Bearer " <> token)
      conn = get(conn, Routes.auth_path(conn, :index))
      assert response(conn, 204) == ""
    end

    test "renders errors when not authorized", %{conn: conn} do
      conn = get(conn, Routes.auth_path(conn, :index))
      assert json_response(conn, 401)["errors"] != %{}
    end

    test "renders errors when token is invalid", %{conn: conn} do
      conn = conn
      |> put_req_header("authorization", "Bearer invalidtoken")
      conn = get(conn, Routes.auth_path(conn, :index))
      assert json_response(conn, 401)["errors"] != %{}
    end
  end
end
