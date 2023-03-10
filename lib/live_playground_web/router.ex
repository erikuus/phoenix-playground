defmodule LivePlaygroundWeb.Router do
  use LivePlaygroundWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LivePlaygroundWeb.Layouts, :root}
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
    live "/changes", ChangesLive
    live "/send-interval", SendIntervalLive
    live "/send-after", SendAfterLive
    live "/search", SearchLive
    live "/search-advanced", SearchAdvancedLive
    live "/autocomplete", AutocompleteLive
    live "/autocomplete-advanced", AutocompleteAdvancedLive
    live "/filter", FilterLive
    live "/filter-advanced", FilterAdvancedLive

    live "/modals", ModalsLive
    # modals
    live "/modals-advanced", ModalsAdvancedLive
    live "/modals-advanced/text", ModalsAdvancedLive, :text
    live "/modals-advanced/math", ModalsAdvancedLive, :math
    live "/modals-advanced/image", ModalsAdvancedLive, :image
    # endmodals

    live "/upload", UploadLive

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", LivePlaygroundWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:live_playground, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LivePlaygroundWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
