defmodule Streakable.Repo.Migrations.CreateObjective do
  use Ecto.Migration

  def change do
    create table(:objectives) do
      add :name, :string
      add :description, :string
      add :frequency, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:objectives, [:user_id])

  end
end
