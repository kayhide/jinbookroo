defmodule JinbookrooWeb.PersonView do
  use JinbookrooWeb, :view
  alias JinbookrooWeb.PersonView

  def render("index.json", %{persons: persons}) do
    render_many(persons, PersonView, "person.json")
  end

  def render("show.json", %{person: person}) do
    render_one(person, PersonView, "person.json")
  end

  def render("person.json", %{person: person}) do
    %{id: person.id,
      name: person.name}
  end
end
