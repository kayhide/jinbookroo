defmodule Jinbookroo.Books.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jinbookroo.Books

  schema "entries" do
    field :description, :string
    field :side, Ecto.Enum, values: [:debit, :credit]
    field :subject, :string
    field :ammount, :integer
    belongs_to :deal, Books.Deal
    belongs_to :person, Books.Person

    timestamps()
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:side, :subject, :ammount, :description])
    |> validate_required([:side, :subject, :ammount])
  end
end
