alias Streakable.Repo
alias Streakable.User

admin_params = %{name:     "Admin User",
                 email:    "admin@streakable.com",
                 password: "streakable",
                 type:     "admin"}

unless Repo.get_by(User, email: admin_params[:email]) do
  %User{}
  |> User.registration_changeset(admin_params)
  |> Repo.insert!
end
