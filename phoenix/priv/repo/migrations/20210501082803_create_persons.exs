defmodule Jinbookroo.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :name, :string

      timestamps()
    end

  end
end
