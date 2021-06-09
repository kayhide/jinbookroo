defmodule JinbookrooWeb.Router do
  use JinbookrooWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:8080"
    plug :accepts, ["json"]
  end

  pipeline :authed do
    plug Guardian.Plug.Pipeline,
      module: JinbookrooWeb.Auth.Guardian,
      error_handler: JinbookrooWeb.Auth.ErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  scope "/api", JinbookrooWeb do
    pipe_through :api
    post "/auth", AuthController, :create
  end

  scope "/api", JinbookrooWeb do
    pipe_through [:api, :authed]
    get "/auth", AuthController, :index
    resources "/users", UserController, except: [:new, :edit]
    resources "/persons", PersonController, except: [:new, :edit]
    resources "/deals", DealController, except: [:new, :edit]
    resources "/entries", EntryController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: JinbookrooWeb.Telemetry
    end
  end
end
