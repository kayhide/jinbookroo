defmodule JinbookrooWeb.AuthView do
  use JinbookrooWeb, :view

  def render("show.json", %{auth: auth}) do
    %{token: auth.token}
  end
end
