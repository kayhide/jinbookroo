defmodule Jinbookroo.Books.Deal do
  use Ecto.Schema
  import Ecto.Changeset

  alias Jinbookroo.Books

  schema "deals" do
    field :made_on, :date

    timestamps()

    has_many :entries, Books.Entry, on_replace: :delete
  end

  @doc false
  def changeset(deal, attrs) do
    deal
    |> cast(attrs, [:made_on])
    |> validate_required([:made_on])
  end
end
