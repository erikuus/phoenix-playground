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
    end
  end

  live_session :comps,
    layout: {LivePlaygroundWeb.Layouts, :comps},
    on_mount: LivePlaygroundWeb.InitLive do
    scope "/", LivePlaygroundWeb do
      pipe_through :browser

      live "/comps-setup", CompsLive.Setup
      live "/header", CompsLive.Header
      live "/header-demo", CompsLive.HeaderDemo
      live "/modal", CompsLive.Modal
      live "/modal/image", CompsLive.Modal, :image
      live "/modal-basic", CompsLive.ModalBasic
      live "/modal-subtitle", CompsLive.ModalSubtitle
      live "/modal-icon", CompsLive.ModalIcon
      live "/modal-red", CompsLive.ModalRed
      live "/modal-navigate", CompsLive.ModalNavigate
      live "/flash-auto-show", CompsLive.FlashAutoShow
      live "/flash-error-title", CompsLive.FlashErrorTitle
      live "/flash-error-wo-close", CompsLive.FlashErrorWoClose
      live "/flash-info-title", CompsLive.FlashInfoTitle
      live "/flash-text-only", CompsLive.FlashTextOnly
      live "/flash-put-flash", CompsLive.FlashPutFlash
      live "/alert", CompsLive.Alert
      live "/alert-put-flash", CompsLive.AlertPutFlash
      live "/table", CompsLive.Table
      live "/table-action", CompsLive.TableAction
      live "/table-row-click", CompsLive.TableRowClick
      live "/table-stream", CompsLive.TableStream
      live "/input-checkbox", CompsLive.InputCheckbox
      live "/input-radio", CompsLive.InputRadio
      live "/input-select", CompsLive.InputSelect
      live "/input-textarea", CompsLive.InputTextarea
      live "/input-textbox", CompsLive.InputTextbox
      live "/input-label", CompsLive.InputLabel
      live "/input-error", CompsLive.InputError
      live "/button", CompsLive.Button
      live "/simple-form", CompsLive.SimpleForm
      live "/list", CompsLive.List
      live "/icon", CompsLive.Icon
      live "/back", CompsLive.Back
      live "/multi-column-layout", CompsLive.MultiColumnLayout
      live "/multi-column-layout-demo", CompsLive.MultiColumnLayoutDemo
      live "/narrow-sidebar", CompsLive.NarrowSidebar
      live "/narrow-sidebar-demo", CompsLive.NarrowSidebarDemo
      live "/vertical-navigation", CompsLive.VerticalNavigation
      live "/vertical-navigation-sections", CompsLive.VerticalNavigationSections
      live "/vertical-navigation-expandable", CompsLive.VerticalNavigationExpandable
      live "/vertical-navigation-enhanced", CompsLive.VerticalNavigationEnhanced
      live "/slideover", CompsLive.Slideover
      live "/slideover/image", CompsLive.Slideover, :image
      live "/slideover-basic", CompsLive.SlideoverBasic
      live "/slideover-subtitle", CompsLive.SlideoverSubtitle
      live "/slideover-scrollbar", CompsLive.SlideoverScrollbar
      live "/slideover-unobstructed", CompsLive.SlideoverUnobstructed
      live "/slideover-red", CompsLive.SlideoverRed
      live "/slideover-navigate", CompsLive.SlideoverNavigate
      live "/button-link", CompsLive.ButtonLink
      live "/badge", CompsLive.Badge
      live "/note", CompsLive.Note
      live "/simple-list", CompsLive.SimpleList
      live "/steps-navigation", CompsLive.StepsNavigation
      live "/steps-progress", CompsLive.StepsProgress
      live "/tabs", CompsLive.Tabs
      live "/tabs-demo", CompsLive.TabsDemo
      live "/stats", CopmsLive.Stats
      live "/loading", CompsLive.Loading
      live "/pagination", CompsLive.Pagination
      live "/pagination-page", CompsLive.PaginationPage
      live "/pagination-per-page", CompsLive.PaginationPerPage
      live "/pagination-options", CompsLive.PaginationOptions
      live "/pagination-modifier", CompsLive.PaginationModifier
      live "/pagination-modifier-demo", CompsLive.PaginationModifierDemo
      live "/pagination-hook", CompsLive.PaginationHook
      live "/editable", CompsLive.Editable
      live "/circular-progress-bar", CompsLive.CircularProgressBar
      live "/uploads-upload-area", CompsLive.UploadsUploadArea
      live "/uploads-photo-preview-area", CompsLive.UploadsPhotoPreviewArea
    end
  end

  live_session :steps,
    layout: {LivePlaygroundWeb.Layouts, :steps},
    on_mount: LivePlaygroundWeb.InitLive do
    scope "/", LivePlaygroundWeb do
      pipe_through :browser

      live "/steps/generated", StepsLive.Generated.Index, :index
      live "/steps/generated/new", StepsLive.Generated.Index, :new
      live "/steps/generated/:id/edit", StepsLive.Generated.Index, :edit
      live "/steps/generated/:id", StepsLive.Generated.Show, :show
      live "/steps/generated/:id/show/edit", StepsLive.Generated.Show, :edit

      live "/steps/paginated", StepsLive.Paginated.Index, :index
      live "/steps/paginated/new", StepsLive.Paginated.Index, :new
      live "/steps/paginated/:id/edit", StepsLive.Paginated.Index, :edit
      live "/steps/paginated/:id", StepsLive.Paginated.Show, :show
      live "/steps/paginated/:id/show/edit", StepsLive.Paginated.Show, :edit

      live "/steps/refactored", StepsLive.Refactored.Index, :index
      live "/steps/refactored/new", StepsLive.Refactored.Index, :new
      live "/steps/refactored/:id/edit", StepsLive.Refactored.Index, :edit
      live "/steps/refactored/:id", StepsLive.Refactored.Show, :show
      live "/steps/refactored/:id/show/edit", StepsLive.Refactored.Show, :edit

      live "/steps/sorted", StepsLive.Sorted.Index, :index
      live "/steps/sorted/new", StepsLive.Sorted.Index, :new
      live "/steps/sorted/:id/edit", StepsLive.Sorted.Index, :edit
      live "/steps/sorted/:id", StepsLive.Sorted.Show, :show
      live "/steps/sorted/:id/show/edit", StepsLive.Sorted.Show, :edit

      live "/steps/filtered", StepsLive.Filtered.Index, :index
      live "/steps/filtered/new", StepsLive.Filtered.Index, :new
      live "/steps/filtered/:id/edit", StepsLive.Filtered.Index, :edit
      live "/steps/filtered/:id", StepsLive.Filtered.Show, :show
      live "/steps/filtered/:id/show/edit", StepsLive.Filtered.Show, :edit
    end
  end

  scope "/", LivePlaygroundWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/rules", PageController, :rules
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
