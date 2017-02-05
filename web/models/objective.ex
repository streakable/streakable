defmodule Streakable.Objective do
  use Streakable.Web, :model

  schema "objectives" do
    field :name            , :string
    field :description     , :string
    belongs_to :user       , Streakable.User
    has_many :contributions, Streakable.Contribution

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @required_fields ~w(name)a
  @optional_fields ~w(description)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
  end
end
