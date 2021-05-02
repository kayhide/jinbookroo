defmodule Jinbookroo.BooksTest do
  use Jinbookroo.DataCase

  alias Jinbookroo.Books

  describe "persons" do
    alias Jinbookroo.Books.Person

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def person_fixture(attrs \\ %{}) do
      {:ok, person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Books.create_person()

      person
    end

    test "list_persons/0 returns all persons" do
      person = person_fixture()
      assert Books.list_persons() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Books.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      assert {:ok, %Person{} = person} = Books.create_person(@valid_attrs)
      assert person.name == "some name"
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      assert {:ok, %Person{} = person} = Books.update_person(person, @update_attrs)
      assert person.name == "some updated name"
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_person(person, @invalid_attrs)
      assert person == Books.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Books.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Books.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Books.change_person(person)
    end
  end

  describe "deals" do
    alias Jinbookroo.Books.Deal

    @valid_attrs %{made_on: ~D[2010-04-17]}
    @update_attrs %{made_on: ~D[2011-05-18]}
    @invalid_attrs %{made_on: nil}

    def deal_fixture(attrs \\ %{}) do
      {:ok, deal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Books.create_deal()

      deal
    end

    test "list_deals/0 returns all deals" do
      deal = deal_fixture()
      assert Books.list_deals() == [deal]
    end

    test "get_deal!/1 returns the deal with given id" do
      deal = deal_fixture()
      assert Books.get_deal!(deal.id) == deal
    end

    test "create_deal/1 with valid data creates a deal" do
      assert {:ok, %Deal{} = deal} = Books.create_deal(@valid_attrs)
      assert deal.made_on == ~D[2010-04-17]
    end

    test "create_deal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_deal(@invalid_attrs)
    end

    test "update_deal/2 with valid data updates the deal" do
      deal = deal_fixture()
      assert {:ok, %Deal{} = deal} = Books.update_deal(deal, @update_attrs)
      assert deal.made_on == ~D[2011-05-18]
    end

    test "update_deal/2 with invalid data returns error changeset" do
      deal = deal_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_deal(deal, @invalid_attrs)
      assert deal == Books.get_deal!(deal.id)
    end

    test "delete_deal/1 deletes the deal" do
      deal = deal_fixture()
      assert {:ok, %Deal{}} = Books.delete_deal(deal)
      assert_raise Ecto.NoResultsError, fn -> Books.get_deal!(deal.id) end
    end

    test "change_deal/1 returns a deal changeset" do
      deal = deal_fixture()
      assert %Ecto.Changeset{} = Books.change_deal(deal)
    end
  end

  describe "entries" do
    alias Jinbookroo.Books.Entry

    @valid_attrs %{description: "some description", side: :debit, subject: "some subject"}
    @update_attrs %{description: "some updated description", side: :credit, subject: "some updated subject"}
    @invalid_attrs %{description: nil, side: nil, subject: nil}

    def entry_fixture(attrs \\ %{}) do
      {:ok, entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Books.create_entry()

      entry
    end

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Books.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Books.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      assert {:ok, %Entry{} = entry} = Books.create_entry(@valid_attrs)
      assert entry.description == "some description"
      assert entry.side == :debit
      assert entry.subject == "some subject"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Books.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{} = entry} = Books.update_entry(entry, @update_attrs)
      assert entry.description == "some updated description"
      assert entry.side == :credit
      assert entry.subject == "some updated subject"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Books.update_entry(entry, @invalid_attrs)
      assert entry == Books.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Books.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Books.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Books.change_entry(entry)
    end
  end
end
