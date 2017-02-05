defmodule Streakable.ObjectiveControllerTest do
  use Streakable.ConnCase

  alias Streakable.User
  alias Streakable.Objective
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{name: nil}

  @user_params %{
    email:    "kumabook@example.com",
    name:     "kumabook",
    password: "kumabook_password",
    type:     "member"
  }

  @objective_params %{
    name:        "programming",
    description: "programming",
  }

  setup do
    Repo.insert!(User.registration_changeset(%User{}, @user_params))
    user = Repo.get_by!(User, email: "kumabook@example.com")
    objectives = [Objective.changeset(%Objective{user: user}, @objective_params)]

    Enum.each(objectives, &Repo.insert!(&1))
    {:ok, %{user: user, objectives: objectives}}
  end

  test "lists all entries on index", %{user: user} do
    conn = guardian_login(user)
    conn = get conn, user_objective_path(conn, :index, user)

    {:ok, conn: conn}
    assert html_response(conn, 200) =~ "My Objectives"
  end

  test "render form for new resources", %{user: user} do
    conn = guardian_login(user)
    conn = get conn, user_objective_path(conn, :new, user)
    {:ok, conn: conn}
    assert html_response(conn, 200) =~ "New Objective"
  end

  test "creates resource and redirects when data is valid", %{user: user} do
    conn = guardian_login(user)
    conn = post conn, user_objective_path(conn, :create, user), objective: @valid_attrs
    assert redirected_to(conn) == user_objective_path(conn, :index, user)
    assert Repo.get_by(Objective, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{user: user} do
    conn = guardian_login(user)
    conn = post conn, user_objective_path(conn, :create, user), objective: @invalid_attrs
    assert html_response(conn, 200) =~ "New Objective"
  end

  test "shows chosen resource", %{user: user} do
    objective = Repo.insert! Objective.changeset(%Objective{user: user}, @objective_params)
    conn = guardian_login(user)
    conn = get conn, user_objective_path(conn, :show, user, objective)
    assert html_response(conn, 200) =~ "Show Objective"
  end

  test "renders page not found when id is noexistent", %{user: user} do
    conn = guardian_login(user)
    conn = get conn, user_objective_path(conn, :show, user, -1)
    assert html_response(conn, 404)
  end

  test "renders form for editing chosen resource", %{user: user} do
    objective = Repo.insert! Objective.changeset(%Objective{user: user}, @objective_params)
    conn = guardian_login(user)
    conn = get conn, user_objective_path(conn, :edit, user, objective)
    {:ok, conn: conn}
    assert html_response(conn, 200) =~ "Edit Objective"
  end

  test "updates chosen resource and redirects when data is valid", %{user: user} do
    objective = Repo.insert! Objective.changeset(%Objective{user: user}, @objective_params)
    conn = guardian_login(user)
    conn = put conn, user_objective_path(conn, :update, user, objective), objective: @valid_attrs

    assert redirected_to(conn) == user_objective_path(conn, :show, user, objective)
    assert Repo.get_by(Objective, @valid_attrs)
  end

  test "does not update chosen resource and renders erros when data is invalid", %{user: user} do
    objective = Repo.insert! Objective.changeset(%Objective{user: user}, @objective_params)
    conn = guardian_login(user)
    conn = put conn, user_objective_path(conn, :update, user, objective), objective: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Objective"
  end

  test "deletes chose resource", %{user: user} do
    objective = Repo.insert! Objective.changeset(%Objective{user: user}, @objective_params)
    conn = guardian_login(user)
    conn = delete conn, user_objective_path(conn, :delete, user, objective)
    assert redirected_to(conn) == user_objective_path(conn, :index, user)
    refute Repo.get(Objective, objective.id)
  end
end
