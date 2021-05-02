defmodule JinbookrooWeb.EntryView do
  use JinbookrooWeb, :view
  alias JinbookrooWeb.EntryView

  def render("index.json", %{entries: entries}) do
    render_many(entries, EntryView, "entry.json")
  end

  def render("show.json", %{entry: entry}) do
    render_one(entry, EntryView, "entry.json")
  end

  def render("entry.json", %{entry: entry}) do
    %{id: entry.id,
      side: entry.side,
      subject: entry.subject,
      description: entry.description}
  end
end
