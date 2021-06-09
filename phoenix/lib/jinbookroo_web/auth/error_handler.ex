defmodule JinbookrooWeb.Auth.ErrorHandler do
  use JinbookrooWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> put_view(JinbookrooWeb.ErrorView)
    |> render(:"401")
  end
end
