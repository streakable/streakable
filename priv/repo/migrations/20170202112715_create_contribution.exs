defmodule Streakable.Repo.Migrations.CreateContribution do
  use Ecto.Migration

  def change do
    create table(:contributions) do
      add :comment, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :objective_id, references(:objectives, on_delete: :nothing)

      timestamps()
    end
    create index(:contributions, [:user_id])
    create index(:contributions, [:objective_id])

  end
end
