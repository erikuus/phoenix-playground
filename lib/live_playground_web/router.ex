defmodule LivePlaygroundWeb.Router do
  use LivePlaygroundWeb, :router

  import LivePlaygroundWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LivePlaygroundWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  live_session :recipes,
    layout: {LivePlaygroundWeb.Layouts, :recipes},
    on_mount: [LivePlaygroundWeb.InitLive, {LivePlaygroundWeb.UserAuth, :mount_current_user}] do
    scope "/", LivePlaygroundWeb do
      pipe_through :browser

      live "/recipes-introduction", RecipesLive.Introduction
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
      live "/form-validate-on-submit", RecipesLive.FormValidateOnSubmit
      live "/form-validate-on-change", RecipesLive.FormValidateOnChange
      live "/form-validate-improved", RecipesLive.FormValidateImproved
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
    on_mount: [LivePlaygroundWeb.InitLive, {LivePlaygroundWeb.UserAuth, :mount_current_user}] do
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
      live "/avatar", CompsLive.Avatar
      live "/auth-menu", CompsLive.AuthMenu
      live "/auth-menu-custom", CompsLive.AuthMenuCustom
      live "/auth-menu-advanced", CompsLive.AuthMenuAdvanced
      live "/protected-content", CompsLive.ProtectedContent
      live "/protected-content-bg-image", CompsLive.ProtectedContentBgImage
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

  live_session :grids,
    layout: {LivePlaygroundWeb.Layouts, :grids},
    on_mount: [LivePlaygroundWeb.InitLive, {LivePlaygroundWeb.UserAuth, :mount_current_user}] do
    scope "/", LivePlaygroundWeb do
      pipe_through :browser

      live "/grids/introduction", GridsLive.Index, :index

      live "/grids/generated", GridsLive.Generated.Index, :index
      live "/grids/generated/new", GridsLive.Generated.Index, :new
      live "/grids/generated/:id/edit", GridsLive.Generated.Index, :edit
      live "/grids/generated/:id", GridsLive.Generated.Show, :show
      live "/grids/generated/:id/show/edit", GridsLive.Generated.Show, :edit

      live "/grids/paginated", GridsLive.Paginated.Index, :index
      live "/grids/paginated/new", GridsLive.Paginated.Index, :new
      live "/grids/paginated/:id/edit", GridsLive.Paginated.Index, :edit
      live "/grids/paginated/:id", GridsLive.Paginated.Show, :show
      live "/grids/paginated/:id/show/edit", GridsLive.Paginated.Show, :edit

      live "/grids/refactored", GridsLive.Refactored.Index, :index
      live "/grids/refactored/new", GridsLive.Refactored.Index, :new
      live "/grids/refactored/:id/edit", GridsLive.Refactored.Index, :edit
      live "/grids/refactored/:id", GridsLive.Refactored.Show, :show
      live "/grids/refactored/:id/show/edit", GridsLive.Refactored.Show, :edit

      live "/grids/sorted", GridsLive.Sorted.Index, :index
      live "/grids/sorted/new", GridsLive.Sorted.Index, :new
      live "/grids/sorted/:id/edit", GridsLive.Sorted.Index, :edit
      live "/grids/sorted/:id", GridsLive.Sorted.Show, :show
      live "/grids/sorted/:id/show/edit", GridsLive.Sorted.Show, :edit

      live "/grids/filtered", GridsLive.Filtered.Index, :index
      live "/grids/filtered/new", GridsLive.Filtered.Index, :new
      live "/grids/filtered/:id/edit", GridsLive.Filtered.Index, :edit
      live "/grids/filtered/:id", GridsLive.Filtered.Show, :show
      live "/grids/filtered/:id/show/edit", GridsLive.Filtered.Show, :edit
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

  ## Authentication routes

  scope "/", LivePlaygroundWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{LivePlaygroundWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", AuthLive.Registration, :new
      live "/users/log_in", AuthLive.Login, :new
      live "/users/reset_password", AuthLive.ForgotPassword, :new
      live "/users/reset_password/:token", AuthLive.ResetPassword, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", LivePlaygroundWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{LivePlaygroundWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", AuthLive.Settings, :edit
      live "/users/settings/confirm_email/:token", AuthLive.Settings, :confirm_email
    end
  end

  scope "/", LivePlaygroundWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{LivePlaygroundWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", AuthLive.Confirmation, :edit
      live "/users/confirm", AuthLive.ConfirmationInstructions, :new
    end
  end

  # Example: Requiring confirmed email for specific routes
  #
  # This scope demonstrates how to protect routes that require both authentication
  # AND email confirmation. The plugs work in sequence:
  # 1. :require_authenticated_user - Ensures user is logged in
  # 2. :require_confirmed_user - Ensures user has confirmed their email
  #
  # Use this pattern when you want to restrict access to features that should only
  # be available to users who have verified their email address. For example:
  # - Admin panels or sensitive operations
  # - Payment or billing pages
  # - Features that send emails on behalf of the user
  #
  # scope "/", LivePlaygroundWeb do
  #   pipe_through [:browser, :require_authenticated_user, :require_confirmed_user]
  # end
end
