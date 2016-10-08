defmodule Streakable.ObjectiveController do
  use Streakable.Web, :controller

  alias Streakable.Objective

  def index(conn, _params) do
    objective = Repo.all(Objective)
    render(conn, "index.html", objective: objective)
  end

  def new(conn, _params) do
    changeset = Objective.changeset(%Objective{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"objective" => objective_params}) do
    changeset = Objective.changeset(%Objective{}, objective_params)

    case Repo.insert(changeset) do
      {:ok, _objective} ->
        conn
        |> put_flash(:info, "Objective created successfully.")
        |> redirect(to: objective_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    objective = Repo.get!(Objective, id)
    render(conn, "show.html", objective: objective)
  end

  def edit(conn, %{"id" => id}) do
    objective = Repo.get!(Objective, id)
    changeset = Objective.changeset(objective)
    render(conn, "edit.html", objective: objective, changeset: changeset)
  end

  def update(conn, %{"id" => id, "objective" => objective_params}) do
    objective = Repo.get!(Objective, id)
    changeset = Objective.changeset(objective, objective_params)

    case Repo.update(changeset) do
      {:ok, objective} ->
        conn
        |> put_flash(:info, "Objective updated successfully.")
        |> redirect(to: objective_path(conn, :show, objective))
      {:error, changeset} ->
        render(conn, "edit.html", objective: objective, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    objective = Repo.get!(Objective, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(objective)

    conn
    |> put_flash(:info, "Objective deleted successfully.")
    |> redirect(to: objective_path(conn, :index))
  end
end
