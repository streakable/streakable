defmodule Streakable.Repo.Migrations.CreateObjective do
  use Ecto.Migration

  def change do
    create table(:objectives) do
      add :name       , :string
      add :description, :string
      add :frequency  , :integer

      timestamps()
    end

  end
end
