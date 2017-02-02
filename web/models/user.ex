defmodule Streakable.User do
  use Streakable.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :type, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :password_hash, :type])
    |> validate_required([:email, :name, :password_hash, :type])
  end
end
