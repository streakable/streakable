defmodule Streakable.ContributionController do
  use Streakable.Web, :controller

  alias Streakable.Contribution
  alias Streakable.User
  alias Streakable.Objective

  plug :scrub_params, "contribution" when action in [:create]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id, "objective_id" => objective_id}, _current_user) do
    user      = User      |> Repo.get!(user_id)
    objective = Objective |> Repo.get!(objective_id)

    contributions =
      objective
      |> objective_contributions
      |> Repo.all
      |> Repo.preload(:user)

    render(conn, "index.html", contributions: contributions,
                                        user: user,
                                   objective: objective)
  end

  def new(conn, %{"objective_id" => objective_id}, current_user) do
    objective = Objective |> Repo.get!(objective_id)
    changeset =
      objective
      |> build_assoc(:contributions)
      |> Contribution.changeset
    render(conn, "new.html", changeset: changeset, objective: objective)
  end

  def create(conn, %{"contribution" => contribution_params, "objective_id" => objective_id}, current_user) do
    objective = Objective |> Repo.get!(objective_id)
    changeset =
      Contribution.changeset(%Contribution{}, contribution_params)
      |> Ecto.Changeset.put_assoc(:objective, objective)
      |> Ecto.Changeset.put_assoc(:user, current_user)
    case Repo.insert(changeset) do
      {:ok, _contribution} ->
        conn
        |> put_flash(:info, "Contribution was created successfully.")
        |> redirect(to: user_objective_contribution_path(
              conn,
            :index,
            current_user.id,
            objective_id)
        )
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "objective_id" => objective_id, "id" => id}, current_user) do
    objective    = Objective |> Repo.get!(objective_id)
    contribution = objective |> objective_contribution_by_id(id) |> Repo.preload(:user)

    if current_user.id == contribution.user.id || current_user.type == "admin" do
      Repo.delete!(contribution)

      conn
      |> put_flash(:info, "Contribution was deleted successfully.")
      |> redirect(to: user_objective_contribution_path(conn, :index, current_user.id, objective_id))
    else
      conn
      |> put_flash(:info, "You can't delete this contribution")
      |> redirect(to: user_objective_contribution_path(conn, :show, user_id, objective_id, contribution.id))
    end
  end

  defp objective_contributions(objective) do
    assoc(objective, :contributions)
  end

  defp objective_contribution_by_id(objective, contribution_id) do
    objective
    |> objective_contributions
    |> Repo.get(contribution_id)
  end
end
