defmodule Jinbookroo.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Jinbookroo.Repo

  alias Jinbookroo.Books.Person
  alias Jinbookroo.Books.Deal
  alias Jinbookroo.Books.Entry

  # Persons
  def list_persons do
    Repo.all(Person)
  end

  def get_person!(id), do: Repo.get!(Person, id)

  def with_person(record) do
    Repo.preload(record, :person)
  end

  def create_person(attrs \\ %{}) do
    %Person{}
    |> Person.changeset(attrs)
    |> Repo.insert()
  end

  def update_person(%Person{} = person, attrs) do
    person
    |> Person.changeset(attrs)
    |> Repo.update()
  end

  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  def change_person(%Person{} = person, attrs \\ %{}) do
    Person.changeset(person, attrs)
  end


  # Deals
  def with_deal(record) do
    Repo.preload(record, :deal)
  end

  def list_deals do
    Repo.all(Deal)
  end

  def get_deal!(id), do: Repo.get!(Deal, id)

  def create_deal(attrs \\ %{}) do
    %Deal{}
    |> Deal.changeset(attrs)
    |> Repo.insert()
  end

  def create_deal_with_entries(attrs \\ %{}) do
    entries_attrs = case attrs do
      %{entries: entries} -> entries
      %{"entries" => entries} -> entries
      _ -> []
    end
    %Deal{}
    |> Deal.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:entries, entries_attrs |> Enum.map(&(Entry.changeset(%Entry{}, &1))))
    |> Repo.insert()
  end

  def update_deal(%Deal{} = deal, attrs) do
    deal
    |> Deal.changeset(attrs)
    |> Repo.update()
  end

  def update_deal_with_entries(%Deal{} = deal, attrs) do
    entries_attrs = case attrs do
      %{entries: entries} -> entries
      %{"entries" => entries} -> entries
      _ -> []
    end
    deal
    |> Deal.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:entries, entries_attrs |> Enum.map(&(Entry.changeset(%Entry{}, &1))))
   |> Repo.update()
  end

  def delete_deal(%Deal{} = deal) do
    Repo.delete(deal)
  end

  def change_deal(%Deal{} = deal, attrs \\ %{}) do
    Deal.changeset(deal, attrs)
  end


  # Entries
  def with_entries(record) do
    Repo.preload(record, [entries: from(e in Entry, order_by: e.id)])
  end

  def list_entries(%{"person_id" => person_id}) do
    Repo.all(
      from e in Entry,
        where: e.person_id == ^person_id
    )
  end

  def list_entries do
    Repo.all(Entry)
  end

  def get_entry!(id), do: Repo.get!(Entry, id)

  def create_entry(attrs \\ %{}) do
    [person, attrs] = case attrs do
        %{person: person} -> [person, attrs |> Map.delete(:person) |> Map.put(:person_id, person.id)]
        %{"person" => person} -> [person, attrs |> Map.delete("person") |> Map.put(:person_id, person.id)]
        _ -> [nil, attrs]
      end
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
    |> case do
        {:ok, entry} -> {:ok, entry |> Map.update!(:person, &(if person, do: person, else: &1))}
        otherwise -> otherwise
      end
  end

  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end
end
