defmodule Streakable.ContributionController do
  use Streakable.Web, :controller

  alias Streakable.Contribution
  alias Streakable.User

  plug :scrub_params, "contribution" when action in [:create]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, %{"user_id" => user_id}, _current_user) do
    user = User |> Repo.get!(user_id)

    contributions =
      user
      |> user_contributions
      |> Repo.all
      |> Repo.preload(:user)

    render(conn, "index.html", contributions: contributions, user: user)
  end

  def new(conn, _params, current_user) do
    changeset =
      current_user
      |> build_assoc(:contributions)
      |> Contribution.changeset
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"contribution" => contribution_params}, current_user) do
    changeset =
      current_user
      |> build_assoc(:contributions)
      |> Contribution.changeset(contribution_params)

    case Repo.insert(changeset) do
      {:ok, _contribution} ->
        conn
        |> put_flash(:info, "Contribution was created successfully.")
        |> redirect(to: user_contribution_path(conn, :index, current_user.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}, current_user) do
    user         = User |> Repo.get!(user_id)
    contribution = user |> user_contribution_by_id(id) |> Repo.preload(:user)

    if current_user.id == contribution.user.id || current_user.type == "admin" do
      Repo.delete!(contribution)

      conn
      |> put_flash(:info, "Contribution was deleted successfully.")
      |> redirect(to: user_contribution_path(conn, :index, current_user.id))
    else
      conn
      |> put_flash(:info, "You can't delete this contribution")
      |> redirect(to: user_contribution_path(conn, :show, user.id, contribution.id))
    end
  end

  defp user_contributions(user) do
    assoc(user, :contributions)
  end

  defp user_contribution_by_id(user, contribution_id) do
    user
    |> user_contributions
    |> Repo.get(contribution_id)
  end
end
