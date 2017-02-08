defmodule Streakable.Contribution do
  use Streakable.Web, :model

  schema "contributions" do
    field :comment, :string
    belongs_to :user, Streakable.User
    belongs_to :objective, Streakable.Objective

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:comment])
    |> validate_required([:comment])
  end
end
