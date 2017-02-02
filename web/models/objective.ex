defmodule Streakable.Objective do
  use Streakable.Web, :model

  schema "objectives" do
    field :name       , :string
    field :description, :string
    field :frequency  , :integer
    belongs_to :user  , Streakable.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :frequency])
    |> validate_required([:name, :description, :frequency])
  end
end
