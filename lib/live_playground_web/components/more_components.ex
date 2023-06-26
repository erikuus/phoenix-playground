defmodule LivePlaygroundWeb.MoreComponents do
  @moduledoc """
  Provides UI components in addition to core components.
  
  The components in this module use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn how to
  customize the generated components in this module.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  import LivePlaygroundWeb.CoreComponents

  @doc """
  Renders a multi-column layout with left-fixed narrow sidebar, mobile menu for small
  and static menu for larger displays.
  
  ## Examples
  
      <.multi_column_layout>
        <:narrow_sidebar></:narrow_sidebar>
        <:mobile_menu></:mobile_menu>
        <:static_menu></:static_menu>
        <%= @inner_content %>
      </.multi_column_layout>
  """
  slot :narrow_sidebar, required: true
  slot :mobile_menu
  slot :static_menu
  slot :inner_block

  def multi_column_layout(assigns) do
    ~H"""
    <div class="fixed inset-y-0 flex flex-col pl-1.5 pr-1.5 py-1.5 space-y-1 items-center overflow-y-auto bg-zinc-700 w-14 md:w-20 z-20">
      <%= render_slot(@narrow_sidebar) %>
    </div>

    <div :if={@mobile_menu != [] && @static_menu != []} class="pl-14 md:pl-20">
      <div id="mobile-menu" class="relative z-40 hidden" role="dialog" aria-modal="true">
        <div class="fixed inset-0 bg-gray-600 bg-opacity-75 cursor-text"></div>
        
        <div class="fixed inset-0 z-40 flex">
          <div class="relative flex w-full max-w-xs flex-1 flex-col bg-white">
            <div class="absolute top-0 right-0 -mr-12 pt-2">
              <button
                phx-click={JS.hide(to: "#mobile-menu")}
                type="button"
                class="ml-1 flex h-10 w-10 items-center justify-center rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
              >
                <span class="sr-only">Close sidebar</span> <.icon name="hero-x-mark" class="h-6 w-6 text-white" />
              </button>
            </div>
            
            <div class="h-0 flex-1 overflow-y-auto py-3">
              <.focus_wrap
                id="mobile-sidebar-container"
                phx-window-keydown={JS.hide(to: "#mobile-menu")}
                phx-key="escape"
                phx-click-away={JS.hide(to: "#mobile-menu")}
                class="space-y-1 px-2"
              >
                <%= render_slot(@mobile_menu) %>
              </.focus_wrap>
            </div>
          </div>
          
          <div class="w-14 flex-shrink-0">
            <!-- Force sidebar to shrink to fit close icon -->
          </div>
        </div>
      </div>
      
      <div class="hidden lg:fixed lg:inset-y-0 lg:flex lg:w-64 lg:flex-col">
        <div class="flex min-h-0 flex-1 flex-col border-r border-gray-200 bg-white">
          <div class="flex flex-1 flex-col overflow-y-auto">
            <nav class="mt-4 flex-1 space-y-1 bg-white px-3">
              <%= render_slot(@static_menu) %>
            </nav>
          </div>
        </div>
      </div>
      
      <div class="flex flex-1 flex-col lg:pl-64">
        <div class="sticky top-0 z-10 bg-white pl-2.5 pt-2 lg:hidden">
          <button
            phx-click={JS.show(to: "#mobile-menu")}
            type="button"
            class="-mt-0.5 inline-flex h-12 w-12 items-center justify-center rounded-md text-gray-500 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-gray-100"
          >
            <span class="sr-only">Open sidebar</span> <.icon name="hero-bars-3" class="h-6 w-6" />
          </button>
        </div>
        
        <main class="flex-1">
          <div class="lg:py-6">
            <div class="mx-auto max-w-7xl px-6">
              <%= render_slot(@inner_block) %>
            </div>
          </div>
        </main>
      </div>
    </div>
    """
  end

  @doc """
  Renders a list of links for narrow sidebar.
  
  ## Examples
  
      <.narrow_sidebar items={[
        %{
          icon: "hero-home",
          label: "Home",
          path: "/",
          active: true
        }
      ]} />
  """
  attr :items, :list, required: true

  def narrow_sidebar(assigns) do
    ~H"""
    <.link
      :for={item <- @items}
      navigate={item.path}
      class={[
        "group flex w-full flex-col items-center rounded-md p-3 text-xs font-medium",
        item.active == true && "bg-zinc-600 bg-opacity-50 text-white",
        item.active == false && "text-zinc-100 hover:bg-zinc-600 hover:bg-opacity-50 hover:text-white"
      ]}
    >
      <.icon :if={item.icon} name={item.icon} class="text-zinc-300 group-hover:text-white h-6 w-6" />
      <span class="mt-1 hidden md:block"><%= item.label %></span>
    </.link>
    """
  end

  @doc """
  Renders a list of links for vertical navigation.
  
  ## Examples
  
      <.vertical_navigation items={[
        %{
          label: "Group name",
          path: nil
        },
        %{
          icon: "hero-home",
          label: "Home",
          path: "/",
          badge: 2,
          active: true
        }
      ]} />
  """
  attr :items, :list, required: true
  attr :text_class, :string, default: "text-sm"

  def vertical_navigation(assigns) do
    ~H"""
    <div :for={item <- @items}>
      <div :if={!item.path} class="ml-1 font-semibold leading-6 text-gray-400 text-xs">
        <%= item.label %>
      </div>
      
      <.link
        :if={item.path}
        navigate={item.path}
        class={[
          "text-gray-900 group flex items-center px-2 py-2 font-medium rounded-md",
          item.active == true && "bg-gray-100",
          item.active == false && "hover:bg-gray-100",
          @text_class
        ]}
      >
        <.icon :if={item.icon} name={item.icon} class="text-gray-500 mr-1 flex-shrink-0 h-5 w-5" />
        <span class="flex-1 ml-2"><%= item.label %></span>
        <span
          :if={item.badge}
          class={[
            "ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full",
            item.active == true && "bg-gray-200",
            item.active == false && "bg-gray-100 group-hover:bg-gray-200"
          ]}
        >
          <%= item.badge %>
        </span>
      </.link>
    </div>
    """
  end

  @doc """
  Renders a link styled as button.
  
  ## Examples
  
      <.button_link navigate={~p"/page"}>Go</.button_link>
      <.button_link patch={~p"/page"} type="secondary">Refresh</.button_link>
  """
  attr :look, :string, default: "primary"
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate patch)

  slot :inner_block, required: true

  def button_link(assigns) do
    ~H"""
    <.link
      class={[
        "inline-flex items-center justify-center rounded-lg py-2 px-5",
        "text-sm font-semibold leading-6",
        @look == "primary" && "bg-zinc-900 hover:bg-zinc-700 text-white active:text-white/80",
        @look == "secondary" && "border border-zinc-200 bg-zinc-100 hover:bg-zinc-200 text-gray-700 active:text-gray-800",
        @look == "dangerous" && "bg-red-600 hover:bg-red-700 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  @doc """
  Renders an alert box.
  
  ## Examples
  
      <.alert>Info</.alert>
      <.alert type="warning">Warning</.alert>
      <.alert type="error">Error</.alert>
  """
  attr :look, :string, default: "info"
  attr :class, :string, default: "text-sm"

  slot :inner_block, required: true

  def alert(assigns) do
    ~H"""
    <div class={[
      "rounded-md p-4",
      @look == "info" && "bg-blue-50 text-blue-700",
      @look == "warning" && "bg-yellow-50 text-yellow-700",
      @look == "error" && "bg-red-50 text-red-700",
      @class
    ]}>
      <div class="flex space-x-2">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a basic card.
  
  ## Examples
  
      <.card>Content</.card>
      <.card class="mt-6">Content</.card>
  """
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class={["overflow-hidden bg-white shadow-sm border border-gray-200 rounded-md", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a simple list.
  
  ## Examples
  
      <.simple_list>
        <:item :for={item <- @items}><%= item.name %></:item>
      </.simple_list>
  """
  attr :class, :string, default: nil

  slot :item, required: true do
    attr :class, :string
  end

  def simple_list(assigns) do
    ~H"""
    <div class={@class}>
      <dl class="divide-y divide-zinc-100">
        <div :for={item <- @item} class={["flex gap-4 py-4 sm:gap-8", Map.get(item, :class)]}>
          <%= render_slot(item) %>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a list of steps.
  
  ## Examples
  
      <.steps>
        <:step :for={step <- @steps} patch={step.patch} active={step.active}>
          <%= step.name %>
        </:step>
      </.steps>
  """
  attr :class, :string, default: nil

  slot :step, required: true do
    attr :path, :string, required: true
    attr :active, :boolean
  end

  def steps(assigns) do
    assigns = assign(assigns, :last_step, List.last(assigns.step))

    ~H"""
    <ul role="list" class={@class}>
      <li :for={step <- @step} class="relative flex gap-x-2">
        <div class={[
          "absolute mt-2 left-0 top-0 flex w-6 justify-center",
          step == @last_step && "h-6",
          step != @last_step && "-bottom-6"
        ]}>
          <div class="w-px bg-gray-200"></div>
        </div>
        
        <div class="relative flex mt-2 h-6 w-6 flex-none items-center justify-center bg-white">
          <div :if={step.active == false} class="h-1.5 w-1.5 rounded-full bg-gray-100 ring-1 ring-gray-300"></div>
           <.icon :if={step.active == true} name="hero-check-circle" class="h-6 w-6 text-gray-400" />
        </div>
        
        <div class="flex-auto leading-5">
          <.link navigate={step.path} class="block p-2 rounded-md hover:bg-gray-100">
            <%= render_slot(step) %>
          </.link>
        </div>
      </li>
    </ul>
    """
  end

  @doc """
  Renders tabs.
  
  ## Examples
  
      <.tabs>
        <:tab :for={tab <- @tabs} patch={tab.patch} active={tab.active}>
          <%= tab.name %>
        </:tab>
      </.tabs>
  """
  attr :class, :string, default: nil

  slot :tab, required: true do
    attr :patch, :any, required: true
    attr :active, :boolean
  end

  def tabs(assigns) do
    ~H"""
    <div class={["border-b border-gray-200", @class]}>
      <nav class="-mb-px flex space-x-8 flex-wrap md:flex-nowrap">
        <.link
          :for={tab <- @tab}
          patch={tab.patch}
          class={[
            "whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium",
            tab.active == false && "border-transparent text-zinc-400 hover:border-zinc-300",
            tab.active == true && "border-zinc-500 text-zinc-600"
          ]}
        >
          <%= render_slot(tab) %>
        </.link>
      </nav>
    </div>
    """
  end

  @doc """
  Renders a card for statistics.
  
  ## Examples
  
      <.stat>
        <:card title="Orders">
          <%= @orders %>
        </:card>
        <:card title="Amount">
          <%= @amount %>
        </:card>
        <:card title="Satisfaction">
          <%= @satisfaction %>
        </:card>
      </.stat>
  """
  attr :class, :string, default: nil

  slot :card, required: true do
    attr :title, :string, required: true
  end

  def stat(assigns) do
    ~H"""
    <dl class={["grid grid-cols-1 gap-5 sm:grid-cols-3", @class]}>
      <div :for={card <- @card} class="relative overflow-hidden rounded-lg shadow-sm border border-gray-200 bg-white px-4 py-5 sm:p-6">
        <dt class="truncate text-sm font-medium text-gray-500"><%= card.title %></dt>
        
        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">
          <%= render_slot(card) %>
        </dd>
      </div>
    </dl>
    """
  end

  @doc """
  Renders a spinning circle as a loading indicator.
  
  ## Examples
  
      <.loading :if={@loading} />
      <button type="submit">
        Search <.loading :if={@loading} class="ml-2 -mr-2 w-5 h-5" />
      </button>
  """
  attr :class, :string, default: "w-6 h-6"

  def loading(assigns) do
    ~H"""
    <svg class={["animate-spin", @class]} xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      
      <path
        class="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
      >
      </path>
    </svg>
    """
  end

  @doc """
  Renders pagination.
  
  ## Examples
  
      <.pagination
        page={@page}
        per_page={@per_page}
        count_all={@count}
      />
  """
  attr :class, :string, default: nil
  attr :event, :string, required: true
  attr :page, :integer, required: true
  attr :per_page, :integer, required: true
  attr :count_all, :integer, required: true
  attr :limit, :integer, default: 5

  def pagination(assigns) do
    ~H"""
    <nav class={["flex items-center justify-between border-t border-gray-200 px-4 sm:px-0", @class]}>
      <div class="-mt-px flex w-0 flex-1">
        <.link
          :if={@page > 1}
          phx-click={@event}
          phx-value-page={@page - 1}
          class={[
            "inline-flex items-center border-t-2 pt-4 text-sm font-medium pr-4",
            "border-transparent text-zinc-400 hover:border-zinc-300"
          ]}
        >
          <.icon name="hero-arrow-long-left" class="mr-3 h-5 w-5 text-gray-400" /> Previous
        </.link>
      </div>
      
      <div class="hidden lg:-mt-px lg:flex">
        <.link
          :for={page <- get_pages(@page, @per_page, @count_all, @limit)}
          phx-click={@event}
          phx-value-page={page}
          class={[
            "inline-flex items-center border-t-2 pt-4 text-sm font-medium px-4",
            @page != page && "border-transparent text-zinc-400 hover:border-zinc-300",
            @page == page && "border-zinc-500 text-zinc-600"
          ]}
        >
          <%= page %>
        </.link>
      </div>
      
      <div class="-mt-px flex w-0 flex-1 justify-end">
        <.link
          :if={@page * @per_page < @count_all}
          phx-click={@event}
          phx-value-page={@page + 1}
          class={[
            "inline-flex items-center border-t-2 pt-4 text-sm font-medium pl-4",
            "border-transparent text-zinc-400 hover:border-zinc-300"
          ]}
        >
          Next <.icon name="hero-arrow-long-right" class="ml-3 h-5 w-5 text-gray-400" />
        </.link>
      </div>
    </nav>
    """
  end

  def get_pages(page, per_page, count_all, limit) do
    page_count = ceil(count_all / per_page)

    for page_number <- (page - limit)..(page + limit),
        page_number > 0 and page_number <= page_count do
      page_number
    end
  end

  @doc """
  Renders an editable content.
  
  Editable field has two blocks: (1) inner block content with edit link
  and (2) input field(s) block with save and cancel buttons. Edit link,
  save and cancel buttons are pointing to events that must be defined in
  liveview that renders this component.
  
  ## Examples
  
      <div id="country" phx-update="replace">
        <.list class="mt-6 mb-16 ml-1">
          <:item title="Name"><%= @user.name %></:item>
          <:item title="Email">
            <.editable id="email" form={@form} edit={@edit_field == "email"}>
              <%= @user.email %>
              <:input_block>
                <.input field={@form[:email]} type="email" />
              </:input_block>
            </.editable>
          </:item>
        </.list>
      </div>
  """
  attr :id, :string, required: true
  attr :form, :map, required: true
  attr :edit, :boolean, required: true
  attr :save_event, :string, default: "save"
  attr :edit_event, :string, default: "edit"
  attr :cancel_event, :string, default: "cancel"

  slot :inner_block, required: true
  slot :input_block, required: true

  def editable(assigns) do
    ~H"""
    <div :if={!@edit} class="w-full flex items-center justify-between">
      <div id={@id}>
        <%= render_slot(@inner_block) %>
      </div>
      
      <.link phx-click={@edit_event} phx-value-field={@id}>
        <span class="hidden md:inline font-bold">Edit</span> <.icon name="hero-pencil-square-mini" class="md:hidden h-6 w-6" />
      </.link>
    </div>

    <.form
      :if={@edit}
      for={@form}
      phx-submit={@save_event}
      class="flex flex-col space-x-0 space-y-2 md:flex-row md:space-x-2 md:space-y-0"
    >
      <%= render_slot(@input_block) %>
      <div>
        <.button class="w-full md:w-auto" phx-disable-with="">Save</.button>
      </div>
      
      <div>
        <.button_link type="secondary" class="w-full md:w-auto" phx-click={@cancel_event}>Cancel</.button_link>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a slideover.
  
  ## Examples
  
      <.slideover id="menu">
        ...
      </.slideover>
  
  JS commands may be passed to the `:on_cancel` and `on_confirm` attributes
  for the caller to react to each button press, for example:
  
      <.slideover id="confirm" on_confirm={JS.push("delete")} on_cancel={JS.navigate(~p"/items")}>
        Are you sure to delete these items?
        ...
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.slideover>
  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}
  attr :width_class, :string, default: "max-w-md"

  slot :inner_block, required: true
  slot :title
  slot :subtitle

  slot :confirm do
    attr :class, :string
  end

  slot :cancel

  def slideover(assigns) do
    ~H"""
    <div
      class="relative z-50"
      aria-labelledby={"#{@id}-title"}
      aria-describedby={"#{@id}-description"}
      role="dialog"
      aria-modal="true"
      tabindex="0"
    >
      <div id={"#{@id}-bg"} class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity hidden" />
      <div
        id={@id}
        phx-mounted={@show && show_slideover(@id)}
        phx-remove={hide_slideover(@id)}
        class="fixed inset-0 overflow-hidden hidden"
      >
        <div class="absolute inset-0 overflow-hidden">
          <div class="pointer-events-none fixed inset-y-0 right-0 flex max-w-full pl-10">
            <div class={["pointer-events-auto w-screen", @width_class]}>
              <.focus_wrap
                id={"#{@id}-container"}
                phx-mounted={@show && show_slideover(@id)}
                phx-window-keydown={hide_slideover(@on_cancel, @id)}
                phx-key="escape"
                phx-click-away={hide_slideover(@on_cancel, @id)}
                class="flex h-full flex-col bg-white py-6 shadow-xl px-4 sm:px-6"
              >
                <div class="flex items-start justify-between">
                  <header>
                    <h3 id={"#{@id}-title"} class="text-lg font-medium leading-6 text-gray-900">
                      <%= render_slot(@title) %>
                    </h3>
                    
                    <p :if={@subtitle != []} id={"#{@id}-subtitle"} class="mt-2 text-base leading-6 text-zinc-600">
                      <%= render_slot(@subtitle) %>
                    </p>
                  </header>
                  
                  <div class="ml-3 flex h-7">
                    <.link phx-click={hide_slideover(@on_cancel, @id)}>
                      <.icon name="hero-x-mark-solid" class="w-6 h-6 text-gray-400 hover:text-gray-500" />
                    </.link>
                  </div>
                </div>
                
                <div class="relative mt-6 flex-1 overflow-y-auto">
                  <%= render_slot(@inner_block) %>
                </div>
                
                <div :if={@confirm != [] or @cancel != []} class="border-t border-zinc-200 pt-4 sm:pl-4 sm:flex sm:flex-row-reverse">
                  <.link
                    :for={cancel <- @cancel}
                    phx-click={hide_slideover(@on_cancel, @id)}
                    class={[
                      "inline-flex items-center justify-center rounded-lg border border-zinc-200 bg-zinc-100 hover:bg-zinc-200",
                      "py-2 px-5 text-sm font-semibold leading-6 text-gray-700 active:text-gray-800",
                      "w-full sm:w-auto sm:ml-3"
                    ]}
                  >
                    <%= render_slot(cancel) %>
                  </.link>
                  
                  <.button
                    :for={confirm <- @confirm}
                    phx-click={@on_confirm}
                    id={"#{@id}-confirm"}
                    phx-disable-with
                    class={"w-full sm:w-auto mt-3 sm:mt-0 #{Map.get(confirm, :class, nil)}"}
                  >
                    <%= render_slot(confirm) %>
                  </.button>
                </div>
              </.focus_wrap>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def show_slideover(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(
      to: "##{id}",
      transition: {
        "ease-in-out duration-500 sm:duration-700",
        "translate-x-full",
        "translate-x-0"
      }
    )
    |> JS.show(
      to: "##{id}-bg",
      transition: "fade-in"
    )
    |> JS.add_class(
      "overflow-y-hidden",
      to: "#root-body"
    )
    |> JS.focus_first(to: "##{id}-container")
  end

  def hide_slideover(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: "fade-out"
    )
    |> JS.hide(
      to: "##{id}",
      transition: {
        "ease-in-out duration-500 sm:duration-700",
        "translate-x-0",
        "translate-x-full"
      }
    )
    |> JS.remove_class(
      "overflow-y-hidden",
      to: "#root-body"
    )
    |> JS.pop_focus()
  end
end
