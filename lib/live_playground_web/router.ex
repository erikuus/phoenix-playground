defmodule LivePlaygroundWeb.Router do
  use LivePlaygroundWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LivePlaygroundWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LivePlaygroundWeb do
    pipe_through :browser

    live "/clicks", ClicksLive
    live "/clicks/show-list", ClicksLive, :show_list

    live "/modals", ModalsLive
    live "/modals/single-action", ModalsLive, :single_action
    live "/modals/wide-buttons", ModalsLive, :wide_buttons
    live "/modals/left-buttons", ModalsLive, :left_buttons
    live "/modals/right-buttons", ModalsLive, :right_buttons
    live "/modals/gray-footer", ModalsLive, :gray_footer

    live "/upload", UploadLive
    live "/upload-cloud", UploadCloudLive

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", LivePlaygroundWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LivePlaygroundWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
