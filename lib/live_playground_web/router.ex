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

  live_session :recipes,
    layout: {LivePlaygroundWeb.Layouts, :recipes},
    on_mount: LivePlaygroundWeb.InitLive do
    scope "/", LivePlaygroundWeb do
      pipe_through :browser

      live "/click-buttons", ReceipesLive.ClickButtons
      live "/handle-params", ReceipesLive.HandleParams
      live "/dynamic-form", ReceipesLive.DynamicForm
      live "/send-interval", ReceipesLive.SendInterval
      live "/send-after", ReceipesLive.SendAfter
      live "/search", ReceipesLive.Search
      live "/search-param", ReceipesLive.SearchParam
      live "/autocomplete", ReceipesLive.Autocomplete
      live "/autocomplete-custom", ReceipesLive.AutocompleteCustom
      live "/filter", ReceipesLive.Filter
      live "/filter-params", ReceipesLive.FilterParams
      live "/sort", ReceipesLive.Sort
      live "/sort-params", ReceipesLive.SortParams
      live "/paginate", ReceipesLive.Paginate
      live "/paginate-params", ReceipesLive.PaginateParams
      live "/form-insert", ReceipesLive.FormInsert
      live "/form-insert-validate", ReceipesLive.FormInsertValidate
      live "/form-update-validate", ReceipesLive.FormUpdateValidate
      live "/stream-insert", ReceipesLive.StreamInsert
      live "/stream-update", ReceipesLive.StreamUpdate, :index
      live "/stream-update/edit", ReceipesLive.StreamUpdate, :edit
      live "/tabular-insert", ReceipesLive.TabularInsert
      live "/broadcast", ReceipesLive.Broadcast
      live "/broadcast-stream", ReceipesLive.BroadcastStream, :index
      live "/broadcast-stream/edit", ReceipesLive.BroadcastStream, :edit
      live "/key-events", ReceipesLive.KeyEvents
      live "/js-commands", ReceipesLive.JsCommands
      live "/js-hook-map-dataset", ReceipesLive.JsHookMapDataset
      live "/js-hook-map-push-event", ReceipesLive.JsHookMapPushEvent
      live "/js-hook-map-handle-event", ReceipesLive.JsHookMapHandleEvent
      live "/upload", ReceipesLive.Upload
    end
  end

  live_session :comps,
    layout: {LivePlaygroundWeb.Layouts, :comps},
    on_mount: LivePlaygroundWeb.InitLive do
    scope "/", LivePlaygroundWeb do
      pipe_through :browser

      live "/modal", CompsLive.Modals
      live "/modal/image", CompsLive.Modals, :image
      live "/slideover", CompsLive.Slideover
      live "/slideover/image", CompsLive.Slideover, :image
    end
  end

  live_session :steps,
    layout: {LivePlaygroundWeb.Layouts, :steps},
    on_mount: LivePlaygroundWeb.InitLive do
    scope "/", LivePlaygroundWeb do
      pipe_through :browser

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
