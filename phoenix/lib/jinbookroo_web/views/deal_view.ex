defmodule JinbookrooWeb.DealView do
  use JinbookrooWeb, :view
  alias JinbookrooWeb.DealView

  def render("index.json", %{deals: deals}) do
    render_many(deals, DealView, "deal.json")
  end

  def render("show.json", %{deal: deal}) do
    render_one(deal, DealView, "deal.json")
  end

  def render("deal.json", %{deal: deal}) do
    %{id: deal.id,
      made_on: deal.made_on}
  end
end
