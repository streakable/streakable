defmodule Streakable.ObjectiveController do
  use Streakable.Web, :controller

  alias Streakable.Objective
  alias Streakable.User

  plug :scrub_params, "objective" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id} , _current_user) do
    user = User |> Repo.get!(user_id)

    objectives =
      user
      |> user_objectives
      |> Repo.all
      |> Repo.preload(:user)

    render(conn, "index.html", objectives: objectives, user: user)
  end

  def new(conn, _params, current_user) do
    changeset =
      current_user
      |> build_assoc(:objectives)
      |> Objective.changeset
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"objective" => objective_params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:objectives)
      |> Objective.changeset(objective_params)

    case Repo.insert(changeset) do
      {:ok, _objective} ->
        conn
        |> put_flash(:info, "Objective was created successfully.")
        |> redirect(to: user_objective_path(conn, :index, current_user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user      = User |> Repo.get!(user_id)
    objective = user |> user_objective_by_id(id) |> Repo.preload(:user)
    render(conn, "show.html", objective: objective, user: user)
  end

  def edit(conn, %{"id" => id}, current_user) do
    objective = current_user |> user_objective_by_id(id)

    if objective do
      changeset = Objective.changeset(objective)
      render(conn, "edit.html", objective: objective, changeset: changeset)
    else
      conn
      |> put_status(:not_found)
      |> render(Streakable.ErrorView, "404.html")
    end
  end

  def update(conn, %{"id" => id, "objective" => objective_params}, current_user) do
    objective = current_user |> user_objective_by_id(id)
    changeset = Objective.changeset(objective, objective_params)

    case Repo.update(changeset) do
      {:ok, objective} ->
        conn
        |> put_flash(:info, "Objective was updated successfully.")
        |> redirect(to: user_objective_path(conn, :show, current_user.id, objective.id))
      {:error, changeset} ->
        render(conn, "edit.html", objective: objective, changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user      = User |> Repo.get!(user_id)
    objective = user |> user_objective_by_id(id) |> Repo.preload(:user)

    if current_user.id == objective.user.id || current_user.type == "admin" do
      Repo.delete!(objective)

      conn
      |> put_flash(:info, "Objective was deleted successfully.")
      |> redirect(to: user_objective_path(conn, :index, current_user.id))
    else
      conn
      |> put_flash(:info, "You can't delete this post")
      |> redirect(to: user_objective_path(conn, :show, user.id, objective.id))
    end
  end

  defp user_objectives(user) do
    assoc(user, :objectives)
  end

  defp user_objective_by_id(user, objective_id) do
    user
    |> user_objectives
    |> Repo.get(objective_id)
  end
end
