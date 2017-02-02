defmodule Streakable.User do
  use Streakable.Web, :model

  schema "users" do
    field :email           , :string
    field :name            , :string
    field :password        , :string, virtual: true
    field :password_hash   , :string
    field :type            , :string
    has_many :objectives   , Streakable.Objective
    has_many :contributions, Streakable.Contribution

    timestamps()
  end


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @required_fields ~w(email)a
  @optional_fields ~w(name type)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, ~w(password)a, [])
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password
  end

  defp hash_password(changeset) do
    IO.inspect changeset
    case changeset do
      %Ecto.Changeset{valid?: true,
                      changes: %{password: password}} ->
        put_change(changeset,
                   :password_hash,
                   Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
