defmodule JinbookrooWeb.AuthController do
  use JinbookrooWeb, :controller

  alias Jinbookroo.Accounts.User
  alias JinbookrooWeb.Auth.Guardian

  action_fallback JinbookrooWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, token} <- Guardian.authenticate(email, password) do
      conn
      |> render("show.json", auth: %{token: token})
    end
  end

  def create(conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(JinbookrooWeb.ErrorView)
    |> render(:"422")
  end
end
