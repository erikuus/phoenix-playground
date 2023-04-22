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

  live_session :default, on_mount: LivePlaygroundWeb.InitLive do
    scope "/", LivePlaygroundWeb do
      pipe_through :browser

      live "/click-buttons", ClickButtonsLive
      live "/handle-params", HandleParamsLive
      live "/dynamic-form", DynamicFormLive
      live "/send-interval", SendIntervalLive
      live "/send-after", SendAfterLive
      live "/search", SearchLive
      live "/search-param", SearchParamLive
      live "/autocomplete", AutocompleteLive
      live "/autocomplete-custom", AutocompleteCustomLive
      live "/filter", FilterLive
      live "/filter-params", FilterParamsLive
      live "/sort", SortLive
      live "/paginate", PaginateLive
      live "/modals", ModalsLive
      live "/modals/image", ModalsLive, :image
      live "/modals-advanced/text", ModalsAdvancedLive, :text
      live "/modals-advanced/math", ModalsAdvancedLive, :math
      live "/modals-advanced/image", ModalsAdvancedLive, :image
      live "/form-insert", FormInsertLive
      live "/form-insert-validate", FormInsertValidateLive
      live "/form-update-validate", FormUpdateValidateLive
      live "/stream-insert", StreamInsertLive
      live "/stream-update", StreamUpdateLive, :index
      live "/stream-update/edit", StreamUpdateLive, :edit
      live "/stream-insert-tabular", StreamInsertTabularLive
      live "/stream-pubsub", StreamPubSubLive, :index
      live "/stream-pubsub/edit", StreamPubSubLive, :edit
      live "/upload", UploadLive
      live "/languages", LanguageLive.Index, :index
      live "/languages/new", LanguageLive.Index, :new
      live "/languages/:id/edit", LanguageLive.Index, :edit
      live "/languages/:id", LanguageLive.Show, :show
      live "/languages/:id/show/edit", LanguageLive.Show, :edit
    end
  end

  scope "/", LivePlaygroundWeb do
    pipe_through :browser

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
