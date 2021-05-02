defmodule Jinbookroo.Repo.Migrations.CreateDeals do
  use Ecto.Migration

  def change do
    create table(:deals) do
      add :made_on, :date

      timestamps()
    end

  end
end
