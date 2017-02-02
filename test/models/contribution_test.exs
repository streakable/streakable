defmodule Streakable.ContributionTest do
  use Streakable.ModelCase

  alias Streakable.Contribution

  @valid_attrs %{comment: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Contribution.changeset(%Contribution{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contribution.changeset(%Contribution{}, @invalid_attrs)
    refute changeset.valid?
  end
end
