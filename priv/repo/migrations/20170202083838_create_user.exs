defmodule Streakable.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email        , :string, null: false
      add :name         , :string, null: false
      add :password_hash, :string
      add :type         , :string, default: "member", null: false

      timestamps()
    end

  end
end
