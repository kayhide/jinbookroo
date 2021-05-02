defmodule Jinbookroo.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :side, :string, null: false
      add :subject, :string, null: false
      add :description, :string
      add :ammount, :integer, null: false
      add :deal_id, references(:deals, on_delete: :delete_all)
      add :person_id, references(:persons, on_delete: :restrict)

      timestamps()
    end

    create index(:entries, [:deal_id])
    create index(:entries, [:person_id])
  end
end
