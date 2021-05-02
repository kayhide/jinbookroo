defmodule JinbookrooWeb.DealController do
  use JinbookrooWeb, :controller

  alias Jinbookroo.Books
  alias Jinbookroo.Books.Deal

  action_fallback JinbookrooWeb.FallbackController

  def index(conn, _params) do
    deals = Books.list_deals()
    render(conn, "index.json", deals: deals |> Books.with_entries())
  end

  def create(conn, deal_params) do
    with {:ok, entries_params} <- require_params("entries", deal_params),
         {:ok, %Deal{} = deal} <- Books.create_deal_with_entries(deal_params, entries_params)
      do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.deal_path(conn, :show, deal))
      |> render("show.json", deal: deal |> Books.with_entries())
    end
  end

  def show(conn, %{"id" => id}) do
    deal = Books.get_deal!(id)
    render(conn, "show.json", deal: deal |> Books.with_entries())
  end

  def update(conn, %{"id" => id} = deal_params) do
    deal = Books.get_deal!(id)

    with {:ok, %Deal{} = deal} <- Books.update_deal(deal, deal_params) do
      render(conn, "show.json", deal: deal |> Books.with_entries())
    end
  end

  def delete(conn, %{"id" => id}) do
    deal = Books.get_deal!(id)

    with {:ok, %Deal{}} <- Books.delete_deal(deal) do
      send_resp(conn, :no_content, "")
    end
  end

  defp require_params(key, params) do
    case params do
      %{^key => required_params} -> {:ok, required_params}
      _ -> {:error, :missing_param, key}
    end
  end
end
