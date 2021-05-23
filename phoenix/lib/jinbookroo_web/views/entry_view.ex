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
    made_on = case entry.deal do
        %{made_on: made_on} -> made_on
        _ -> nil
      end
    person_name = case entry.person do
        %{name: name} -> name
        _ -> nil
      end
    %{id: entry.id,
      made_on: made_on,
      ammount: entry.ammount,
      person_id: entry.person_id,
      person_name: person_name,
      side: entry.side,
      subject: entry.subject,
      description: entry.description}
  end
end
