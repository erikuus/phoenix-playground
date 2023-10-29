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

      live "/click-buttons", RecipesLive.ClickButtons
      live "/handle-params", RecipesLive.HandleParams
      live "/change-form", RecipesLive.ChangeForm
      live "/send-interval", RecipesLive.SendInterval
      live "/send-after", RecipesLive.SendAfter
      live "/search", RecipesLive.Search
      live "/search-param", RecipesLive.SearchParam
      live "/autocomplete", RecipesLive.Autocomplete
      live "/autocomplete-custom", RecipesLive.AutocompleteCustom
      live "/filter", RecipesLive.Filter
      live "/filter-params", RecipesLive.FilterParams
      live "/sort", RecipesLive.Sort
      live "/sort-params", RecipesLive.SortParams
      live "/paginate", RecipesLive.Paginate
      live "/paginate-params", RecipesLive.PaginateParams
      live "/form-insert", RecipesLive.FormInsert
      live "/form-insert-validate", RecipesLive.FormInsertValidate
      live "/form-update-validate", RecipesLive.FormUpdateValidate
      live "/stream-insert", RecipesLive.StreamInsert
      live "/stream-update", RecipesLive.StreamUpdate, :index
      live "/stream-update/edit", RecipesLive.StreamUpdate, :edit
      live "/stream-reset", RecipesLive.StreamReset, :index
      live "/stream-reset/edit", RecipesLive.StreamReset, :edit
      live "/tabular-insert", RecipesLive.TabularInsert
      live "/broadcast", RecipesLive.Broadcast
      live "/broadcast-stream", RecipesLive.BroadcastStream, :index
      live "/broadcast-stream/edit", RecipesLive.BroadcastStream, :edit
      live "/broadcast-stream-reset", RecipesLive.BroadcastStreamReset, :index
      live "/broadcast-stream-reset/edit", RecipesLive.BroadcastStreamReset, :edit
      live "/key-events", RecipesLive.KeyEvents
      live "/js-commands", RecipesLive.JsCommands
      live "/js-hook-map-dataset", RecipesLive.JsHookMapDataset
      live "/js-hook-map-push-event", RecipesLive.JsHookMapPushEvent
      live "/js-hook-map-handle-event", RecipesLive.JsHookMapHandleEvent
      live "/upload", RecipesLive.Upload
      live "/upload-cloud", RecipesLive.UploadCloud
      live "/upload-server", RecipesLive.UploadServer
      live "/cities", CityLive.Index, :index
      live "/cities/new", CityLive.Index, :new
      live "/cities/edit", CityLive.Index, :edit
    end
  end

  live_session :comps,
    layout: {LivePlaygroundWeb.Layouts, :comps},
    on_mount: LivePlaygroundWeb.InitLive do
    scope "/", LivePlaygroundWeb do
      pipe_through :browser

      live "/header", CompsLive.Header
      live "/header-demo", CompsLive.HeaderDemo
      live "/modal", CompsLive.Modal
      live "/modal/image", CompsLive.Modal, :image
      live "/flash", CompsLive.Flash
      live "/input", CompsLive.Input
      live "/label", CompsLive.Label
      live "/error", CompsLive.Error
      live "/button", CompsLive.Button
      live "/simple-form", CompsLive.SimpleForm
      live "/table", CompsLive.Table
      live "/list", CompsLive.List
      live "/icon", CompsLive.Icon
      live "/back", CompsLive.Back
      live "/multi-column-layout", CompsLive.MultiColumnLayout
      live "/multi-column-layout-demo", CompsLive.MultiColumnLayoutDemo
      live "/narrow-sidebar", CompsLive.NarrowSidebar
      live "/narrow-sidebar-demo", CompsLive.NarrowSidebarDemo
      live "/vertical-navigation", CompsLive.VerticalNavigation
      live "/vertical-navigation-sections", CompsLive.VerticalNavigationSections
      live "/slideover", CompsLive.Slideover
      live "/slideover/image", CompsLive.Slideover, :image
      live "/button-link", CompsLive.ButtonLink
      live "/alert", CompsLive.Alert
      live "/note", CompsLive.Note
      live "/simple_list", CompsLive.SimpleList
      live "/steps", CompsLive.Steps
      live "/tabs", CompsLive.Tabs
      live "/tabs-demo", CompsLive.TabsDemo
      live "/stats", CopmsLive.Stats
      live "/loading", CompsLive.Loading
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
