defmodule JinbookrooWeb.AuthControllerTest do
  use JinbookrooWeb.ConnCase

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

  describe "create auth" do
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

    test "renders errors when data is invalid", %{conn: conn} do
      user = fixture(:user)
      conn = post(conn, Routes.auth_path(conn, :create), %{email: user.email, password: "notreally"})
      assert json_response(conn, 401)["errors"] != %{}
    end
  end
end
