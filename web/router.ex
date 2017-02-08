defmodule Streakable.Router do
  use Streakable.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Streakable.CurrentUser
  end

  pipeline :login_required do
    plug Guardian.Plug.EnsureAuthenticated,
         handler: Streakable.GuardianErrorHandler
  end

  pipeline :admin_required do
    plug Streakable.CheckAdmin
  end

  scope "/", Streakable do
    pipe_through [:browser, :with_session]

    resources "/users"     , UserController   , only: [:show, :new, :create]
    resources "/sessions"  , SessionController, only: [:new, :create, :delete]
    resources "/objectives", ObjectiveController

    get "/", PageController, :index

    scope "/" do
      pipe_through [:login_required]

      resources "/users", UserController, only: [:show] do
        resources "/objectives", ObjectiveController do
          resources "/contributions", ContributionController
        end
      end
    end
    scope "/admin", Admin, as: :admin do
      pipe_through [:admin_required]

      resources "/users", UserController, only: [:index, :show] do
        resources "/objectives", ObjectiveController, only: [:index, :show]
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Streakable do
  #   pipe_through :api
  # end
end
