defmodule Streakable.ObjectiveTest do
  use Streakable.ModelCase

  alias Streakable.Objective

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Objective.changeset(%Objective{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Objective.changeset(%Objective{}, @invalid_attrs)
    refute changeset.valid?
  end
end
