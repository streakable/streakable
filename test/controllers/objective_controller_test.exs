defmodule Streakable.ObjectiveControllerTest do
  use Streakable.ConnCase

  alias Streakable.Objective
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, objective_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing objective"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, objective_path(conn, :new)
    assert html_response(conn, 200) =~ "New objective"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, objective_path(conn, :create), objective: @valid_attrs
    assert redirected_to(conn) == objective_path(conn, :index)
    assert Repo.get_by(Objective, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, objective_path(conn, :create), objective: @invalid_attrs
    assert html_response(conn, 200) =~ "New objective"
  end

  test "shows chosen resource", %{conn: conn} do
    objective = Repo.insert! %Objective{}
    conn = get conn, objective_path(conn, :show, objective)
    assert html_response(conn, 200) =~ "Show objective"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, objective_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    objective = Repo.insert! %Objective{}
    conn = get conn, objective_path(conn, :edit, objective)
    assert html_response(conn, 200) =~ "Edit objective"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    objective = Repo.insert! %Objective{}
    conn = put conn, objective_path(conn, :update, objective), objective: @valid_attrs
    assert redirected_to(conn) == objective_path(conn, :show, objective)
    assert Repo.get_by(Objective, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    objective = Repo.insert! %Objective{}
    conn = put conn, objective_path(conn, :update, objective), objective: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit objective"
  end

  test "deletes chosen resource", %{conn: conn} do
    objective = Repo.insert! %Objective{}
    conn = delete conn, objective_path(conn, :delete, objective)
    assert redirected_to(conn) == objective_path(conn, :index)
    refute Repo.get(Objective, objective.id)
  end
end
