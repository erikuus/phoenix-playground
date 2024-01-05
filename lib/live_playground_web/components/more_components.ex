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
  and desktop menu for larger displays.

  ## Example

      <.multi_column_layout>
        <:narrow_sidebar></:narrow_sidebar>
        <:mobile_menu></:mobile_menu>
        <:desktop_menu></:desktop_menu>
        <%= @inner_content %>
      </.multi_column_layout>
  """
  slot :narrow_sidebar, required: true
  slot :mobile_menu
  slot :desktop_menu
  slot :inner_block

  def multi_column_layout(assigns) do
    ~H"""
    <div class="fixed inset-y-0 flex flex-col pl-1.5 pr-1.5 py-1.5 space-y-1 items-center overflow-y-auto bg-zinc-700 w-14 md:w-20 z-20">
      <%= render_slot(@narrow_sidebar) %>
    </div>

    <div :if={@mobile_menu != [] && @desktop_menu != []} class="pl-14 md:pl-20">
      <div id="mobile-menu" class="relative z-40 hidden" role="dialog" aria-modal="true">
        <div class="fixed inset-0 bg-gray-600 bg-opacity-75"></div>

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

            <div class="h-0 flex-1 overflow-y-auto p-2">
              <.focus_wrap
                id="mobile-sidebar-container"
                phx-window-keydown={JS.hide(to: "#mobile-menu")}
                phx-key="escape"
                phx-click-away={JS.hide(to: "#mobile-menu")}
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
            <%= render_slot(@desktop_menu) %>
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

  ## Example

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
        "flex w-full flex-col items-center rounded-md p-3 text-xs font-medium",
        item.active == true && "bg-zinc-600 bg-opacity-50 text-white",
        item.active == false && "text-zinc-100 hover:bg-zinc-600 hover:bg-opacity-50 hover:text-white"
      ]}
    >
      <.icon :if={item.icon} name={item.icon} class="h-6 w-6" /> <span class="mt-1 hidden md:block"><%= item.label %></span>
    </.link>
    """
  end

  @doc """
  Renders a vertical navigation.

  ## Example

      <.vertical_navigation id="ver-nav" items={[
        %{
          icon: "hero-map",
          label: "Map",
          path: "/map",
          badge: 3,
          active: false
        },
        %{
          section: %{
            label: "SECTION"
          },
          section_items: [
            %{
              icon: "hero-paper-airplane",
              label: "Paper Airplane",
              path: "/paper-airplane",
              active: true
            },
            %{
              expandable: %{
                id: "squares-plus",
                icon: "hero-squares-plus",
                label: "Squares Plus",
                open: false
              },
              expandable_items: [
                %{
                  label: "Square 1",
                  path: "/square-one",
                  badge: 1,
                  active: false
                },
                %{
                  label: "Square 2",
                  path: "/square-two",
                  badge: 2,
                  active: false
                }
              ]
            }
          ]
        }
      ]} />
  """
  attr :id, :string, required: true
  attr :items, :list, required: true

  def vertical_navigation(assigns) do
    ~H"""
    <nav class="mt-4 bg-white px-3 space-y-1">
      <.vertical_navigation_item :for={item <- @items} id={@id} item={item} />
    </nav>
    """
  end

  @doc """
  Renders a vertical navigation item.

  ## Examples

      <.vertical_navigation_item id="section" item={%{
        section: %{
          label: "SECTION"
        },
        section_items: [
          %{
            icon: "hero-paper-airplane",
            label: "Paper Airplane",
            path: "/paper-airplane",
            active: true
          },
          %{
            icon: "hero-link",
            label: "Link",
            path: "/link",
            active: false
          }
        ]
      }} />

      <.vertical_navigation_item id="expandable" item={%{
        expandable: %{
          id: "squares-plus",
          icon: "hero-squares-plus",
          label: "Squares Plus",
          open: false
        },
        expandable_items: [
          %{
            label: "Square 1",
            path: "/square-one",
            badge: 1,
            active: false
          },
          %{
            label: "Square 2",
            path: "/square-two",
            badge: 2,
            active: false
          }
        ]
      }} />

      <.vertical_navigation_item id="single" item={%{
        icon: "hero-map",
        label: "Map",
        path: "/map",
        badge: 3,
        active: false
      }} />
  """
  attr :id, :string
  attr :item, :map, required: true
  attr :item_class, :string, default: "font-medium text-gray-900 hover:bg-gray-100"
  attr :item_active_class, :string, default: "font-medium text-gray-900 bg-gray-100"

  def vertical_navigation_item(%{item: %{section: %{}, section_items: [%{} | _]}} = assigns) do
    ~H"""
    <div class={["space-y-1", Map.has_key?(@item.section, :class) && @item.section.class]}>
      <div class="ml-2 font-semibold leading-6 text-gray-400 text-xs">
        <%= @item.section.label %>
      </div>
      <.vertical_navigation_item :for={section_item <- @item.section_items} id={@id} item={section_item} />
    </div>
    """
  end

  def vertical_navigation_item(%{item: %{expandable: %{}, expandable_items: [%{} | _]}} = assigns) do
    ~H"""
    <div
      :if={Map.has_key?(@item.expandable, :id)}
      id={"#{@id}-#{@item.expandable.id}"}
      class={["space-y-1", Map.has_key?(@item.expandable, :class) && @item.expandable.class]}
    >
      <button
        phx-click={toggle_expandable("#{@id}-#{@item.expandable.id}")}
        type="button"
        class={["group flex items-center px-2 py-2 rounded-md text-sm w-full text-left", @item_class]}
      >
        <.icon
          :if={Map.has_key?(@item.expandable, :icon)}
          name={@item.expandable.icon}
          class="mr-1 flex-shrink-0 h-5 w-5 text-gray-500"
        />
        <span :if={Map.has_key?(@item.expandable, :label)} class="flex-1 ml-2">
          <%= @item.expandable.label %>
        </span>
        <span
          :if={Map.has_key?(@item.expandable, :badge) && Map.has_key?(@item.expandable, :open)}
          class={[
            "mx-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full",
            @item.expandable.open == false && "bg-gray-100 group-hover:bg-gray-200",
            @item.expandable.open == true && "bg-gray-200"
          ]}
        >
          <%= @item.expandable.badge %>
        </span>
        <.icon
          name="hero-chevron-right"
          class={[
            "mr-1 flex-shrink-0 h-4 w-4 text-gray-500",
            @item.expandable.open == true && "rotate-90"
          ]}
        />
      </button>
      <div class={["ver-nav-exp space-y-1", @item.expandable.open == false && "hidden"]}>
        <.vertical_navigation_item
          :for={expandable_item <- @item.expandable_items}
          item={expandable_item}
          item_class="pl-8 font-normal text-gray-900 hover:bg-gray-100"
          item_active_class="pl-8 font-normal text-gray-900 bg-gray-100"
        />
      </div>
    </div>
    """
  end

  def vertical_navigation_item(assigns) do
    ~H"""
    <.link
      :if={Map.has_key?(@item, :path) && Map.has_key?(@item, :active)}
      navigate={@item.path}
      class={[
        "group flex items-center px-2 py-2 rounded-md text-sm",
        @item.active == false && @item_class,
        @item.active == true && @item_active_class
      ]}
    >
      <.icon
        :if={Map.has_key?(@item, :icon) && Map.has_key?(@item, :active)}
        name={@item.icon}
        class="mr-1 flex-shrink-0 h-5 w-5 text-gray-500"
      />
      <span :if={Map.has_key?(@item, :label)} class="flex-1 ml-2">
        <%= @item.label %>
      </span>
      <span
        :if={Map.has_key?(@item, :badge) && Map.has_key?(@item, :active)}
        class={[
          "ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full",
          @item.active == false && "bg-gray-100 group-hover:bg-gray-200",
          @item.active == true && "bg-gray-200"
        ]}
      >
        <%= @item.badge %>
      </span>
    </.link>
    """
  end

  def toggle_expandable(id) when is_binary(id) do
    %JS{}
    |> JS.toggle(to: "##{id} .ver-nav-exp")
    |> JS.remove_class("rotate-90", to: "##{id} .hero-chevron-right.rotate-90")
    |> JS.add_class("rotate-90", to: "##{id} .hero-chevron-right:not(.rotate-90)")
  end

  @doc """
  Renders a link styled as button.

  ## Examples

      <.button_link navigate={~p"/page"}>Go</.button_link>
      <.button_link patch={~p"/page"} kind={:secondary}>Refresh</.button_link>
  """
  attr :kind, :atom, default: :primary
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(href navigate patch)

  slot :inner_block, required: true

  def button_link(assigns) do
    ~H"""
    <.link
      class={[
        "inline-flex items-center justify-center rounded-lg py-2 px-5",
        "text-sm font-semibold leading-6",
        @kind == :primary && "bg-zinc-900 hover:bg-zinc-700 text-white active:text-white/80",
        @kind == :secondary && "border border-zinc-200 bg-zinc-100 hover:bg-zinc-200 text-gray-700 active:text-gray-800",
        @kind == :dangerous && "bg-red-600 hover:bg-red-700 text-white active:text-white/80",
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
      <.alert kind={:warning}>Warning</.alert>
      <.alert kind={:error}>Error</.alert>
  """
  attr :id, :string, default: "alert"
  attr :kind, :atom, default: :info
  attr :class, :string, default: "text-sm"
  attr :icon, :string, default: nil
  attr :title, :string, default: nil
  attr :close, :boolean, default: true

  slot :inner_block, required: true

  def alert(assigns) do
    ~H"""
    <div
      id={@id}
      phx-click={hide("##{@id}")}
      class={[
        "rounded-md p-4",
        @kind == :info && "bg-zinc-100 text-zinc-600",
        @kind == :success && "bg-green-50 text-green-700",
        @kind == :warning && "bg-yellow-50 text-yellow-700",
        @kind == :error && "bg-red-50 text-red-700",
        @class
      ]}
    >
      <div class="flex items-start">
        <div :if={@icon} class="flex-shrink-0">
          <.icon :if={@icon} name={@icon} />
        </div>

        <div class={["flex-1", @icon != nil && "ml-3"]}>
          <h3 :if={@title} class="font-medium mb-2"><%= @title %></h3>

          <p><%= render_slot(@inner_block) %></p>
        </div>

        <button :if={@close} type="button" class="flex-shrink-0 ml-4" }>
          <.icon name="hero-x-mark-solid" class="w-5 h-5 opacity-40 group-hover:opacity-70" />
        </button>
      </div>
    </div>
    """
  end

  @doc """
  Renders a note as text in card with icon.

  ## Example

      <.note icon="hero-information-circle" class="mt-6">Content</.note>
  """
  attr :class, :string, default: nil
  attr :icon, :string, default: nil
  slot :inner_block, required: true

  def note(assigns) do
    ~H"""
    <div class={["flex flex-col sm:flex-row px-4 py-5 sm:p-6 overflow-hidden shadow-sm border border-gray-200 rounded-md ", @class]}>
      <div :if={@icon} class="flex-shrink-0">
        <.icon name={@icon} class="h-6 w-6" />
      </div>

      <div class="mt-3 sm:ml-3 sm:mt-0">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc """
  Renders a simple list.

  ## Example

      <.simple_list>
        <:item :for={item <- @items}><%= item.name %></:item>
      </.simple_list>
  """
  attr :class, :string, default: nil

  slot :item, required: true do
    attr :class, :any
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

  ## Example

      <.steps>
        <:step :for={step <- @steps} path={step.path} active={step.active}>
          <%= step.name %>
        </:step>
      </.steps>
  """
  attr :class, :string, default: nil

  slot :step, required: true do
    attr :path, :string
    attr :active, :boolean
    attr :checked, :boolean
  end

  def steps(assigns) do
    assigns = assign(assigns, :last_step, List.last(assigns.step))

    ~H"""
    <ul role="list" class={["mt-4 bg-white px-3", @class]}>
      <li :for={step <- @step} class="relative flex gap-x-2">
        <div class={[
          "absolute mt-2 left-0 top-0 flex w-6 justify-center",
          step == @last_step && "h-6",
          step != @last_step && "-bottom-6"
        ]}>
          <div class="w-px bg-gray-200"></div>
        </div>

        <div :if={Map.has_key?(step, :checked)} class="relative flex mt-2 h-6 w-6 flex-none items-center justify-center bg-white">
          <div :if={step.checked == false} class="h-1.5 w-1.5 rounded-full bg-gray-100 ring-1 ring-gray-300"></div>
          <.icon :if={step.checked == true} name="hero-check-circle" class="h-6 w-6 text-gray-400" />
        </div>

        <div :if={!Map.has_key?(step, :checked)} class="relative flex mt-2 h-6 w-6 flex-none items-center justify-center bg-white">
          <div :if={step.active == false} class="h-1.5 w-1.5 rounded-full bg-gray-100 ring-1 ring-gray-300"></div>
          <.icon :if={step.active == true} name="hero-check-circle" class="h-6 w-6 text-gray-400" />
        </div>

        <div class="flex-auto leading-5">
          <div :if={!Map.has_key?(step, :path)} class="block p-2 mb-1 rounded-md">
            <%= render_slot(step) %>
          </div>

          <.link
            :if={Map.has_key?(step, :path) && step.path}
            navigate={step.path}
            class={[
              "block p-2 mb-1 rounded-md",
              step.active == false && "hover:bg-gray-100",
              step.active == true && "bg-gray-100"
            ]}
          >
            <%= render_slot(step) %>
          </.link>
        </div>
      </li>
    </ul>
    """
  end

  @doc """
  Renders tabs.

  ## Example

      <.tabs>
        <:tab :for={tab <- @tabs} patch={tab.patch} active={tab.active}>
          <%= tab.name %>
        </:tab>
      </.tabs>
  """
  attr :id, :string, default: "tabs"
  attr :class, :string, default: nil

  attr :modifier, :string,
    default: nil,
    doc:
      "tailwind modifier to specify screen breakpoint at which the tabs is shown instead of dropdown"

  slot :tab, required: true do
    attr :path, :any, required: true
    attr :active, :boolean
  end

  def tabs(assigns) do
    ~H"""
    <div class={[
      "border-b border-gray-200",
      @modifier && "hidden #{@modifier}:block",
      @class
    ]}>
      <nav class="-mb-px flex space-x-8 flex-wrap md:flex-nowrap">
        <.link
          :for={tab <- @tab}
          navigate={tab.path}
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

    <div :if={@modifier} class={["block #{@modifier}:hidden", @class]}>
      <button
        id={"#{@id}-open"}
        phx-click={JS.show(to: "##{@id}-dropdown") |> JS.hide(to: "##{@id}-open") |> JS.show(to: "##{@id}-close")}
        type="button"
        class="text-zinc-600 py-4 px-1 text-sm font-medium"
      >
        <span class="sr-only">Open tabs</span> <.icon name="hero-ellipsis-vertical" class="h-6 w-6 text-zinc-600" />
      </button>
      <button
        id={"#{@id}-close"}
        type="button"
        phx-click={JS.hide(to: "##{@id}-dropdown") |> JS.hide(to: "##{@id}-close") |> JS.show(to: "##{@id}-open")}
        class="hidden text-zinc-600 py-4 px-1 text-sm font-medium"
      >
        <span class="sr-only">Close tabs</span> <.icon name="hero-x-mark" class="h-6 w-6 text-zinc-600" />
      </button>

      <ul
        id={"#{@id}-dropdown"}
        phx-click-away={JS.hide(to: "##{@id}-dropdown") |> JS.hide(to: "##{@id}-close") |> JS.show(to: "##{@id}-open")}
        class="hidden absolute z-10 -mt-3 rounded-md shadow-lg py-1 border border-gray-200 bg-white"
      >
        <li
          :for={tab <- @tab}
          class={[
            "relative",
            tab.active == false && "hover:bg-zinc-300",
            tab.active == true && "bg-zinc-500 text-white"
          ]}
        >
          <.link navigate={tab.path} class="block py-2 px-8">
            <%= render_slot(tab) %>
          </.link>
        </li>
      </ul>
    </div>
    """
  end

  @doc """
  Renders cards for statistics.

  ## Example

      <.stats>
        <:card title="Orders">
          <%= @orders %>
        </:card>
        <:card title="Amount">
          <%= @amount %>
        </:card>
        <:card title="Satisfaction">
          <%= @satisfaction %>
        </:card>
      </.stats>
  """
  attr :class, :string, default: nil

  slot :card, required: true do
    attr :title, :string, required: true
  end

  def stats(assigns) do
    ~H"""
    <dl class={["grid grid-cols-1 gap-5 sm:grid-cols-3 xl:grid-cols-4", @class]}>
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

      <.button>
        Search <.loading :if={@loading} class="ml-2 -mr-2 w-5 h-5" />
      </.button>
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

  ## Example

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

  ## Example

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

  @doc """
  Renders a file upload area.

  ## Example

      <.uploads_upload_area uploads_name={@uploads.photos} />
  """
  attr :uploads_name, :map, required: true

  def uploads_upload_area(assigns) do
    ~H"""
    <div phx-drop-target={@uploads_name.ref} class="flex justify-center rounded-lg border border-dashed border-zinc-900/25 px-6 py-10">
      <div class="text-center">
        <.icon name="hero-photo" class="mx-auto h-12 w-12 text-zinc-300" />
        <div class="mt-4 flex text-sm leading-6 text-zinc-600">
          <label for={@uploads_name.ref} class="relative cursor-pointer bg-transparent font-semibold">
            <span>Upload a file</span> <.live_file_input upload={@uploads_name} class="sr-only" />
          </label>

          <p class="pl-1">or drag and drop</p>
        </div>

        <p class="text-xs leading-5 text-zinc-600">
          <%= @uploads_name.max_entries %> <%= format_uploads_accept(@uploads_name.accept) %> files up to <%= trunc(
            @uploads_name.max_file_size / 1_000_000
          ) %> MB each
        </p>
      </div>
    </div>
    """
  end

  def format_uploads_accept(accept) do
    accept
    |> String.split(",")
    |> Enum.map(&String.trim_leading(&1, "."))
    |> Enum.map(&String.upcase/1)
    |> Enum.join(", ")
  end

  @doc """
  Renders a preview area for images to be uploaded.

  ## Example

      <.uploads_photo_preview_area uploads_name={@uploads.photos} />
  """
  attr :uploads_name, :map, required: true
  attr :target, :string, default: nil

  def uploads_photo_preview_area(assigns) do
    ~H"""
    <ul role="list" class="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 xl:grid-cols-4">
      <li :for={entry <- @uploads_name.entries}>
        <.live_img_preview
          :if={:not_accepted not in upload_errors(@uploads_name, entry)}
          entry={entry}
          class="object-contain w-full h-28 sm:h-44 rounded-lg bg-zinc-200"
        />
        <div
          :if={:not_accepted in upload_errors(@uploads_name, entry)}
          class="flex items-center justify-center text-xs w-full h-28 sm:h-44 rounded-lg bg-zinc-100 text-ellipsis truncate"
        >
          <%= entry.client_name %>
        </div>

        <div class="flex justify-between items-center space-x-2">
          <div :if={upload_errors(@uploads_name, entry) == []} class="mt-3 flex gap-3 text-sm leading-6">
            <.circular_progress_bar progress={entry.progress} stroke_width={3} radius={7.5} svg_class="mt-0.5 w-5 h-5 flex-none" />
            <div :if={entry.progress > 0}>
              <%= entry.progress %>%
            </div>
          </div>

          <.error :for={err <- upload_errors(@uploads_name, entry)}>
            <%= Phoenix.Naming.humanize(err) %>
          </.error>

          <.link phx-click="cancel" phx-value-ref={entry.ref} phx-target={@target} class="mt-2">
            <.icon name="hero-trash" class="w-5 h-5 text-zinc-400 hover:text-zinc-600" />
          </.link>
        </div>
      </li>
    </ul>
    """
  end

  @doc """
  Renders a circular progress bar

  ## Example

      <.circular_progress_bar progress={50} stroke_width={3} radius={7.5} svg_class="mt-0.5 w-5 h-5 flex-none" />
  """
  attr :progress, :integer, required: true
  attr :stroke_width, :integer, required: true
  attr :radius, :float, required: true
  attr :svg_class, :string, default: nil
  attr :bg_circle_class, :string, default: "text-zinc-300"
  attr :progress_circle_class, :string, default: "text-zinc-600"

  def circular_progress_bar(assigns) do
    assigns =
      assigns
      |> assign_new(:center, fn -> (assigns.radius * 2 + assigns.stroke_width) / 2 end)
      |> assign_new(:circumference, fn -> 2 * Math.pi() * assigns.radius end)

    ~H"""
    <svg class={@svg_class}>
      <circle
        class={@bg_circle_class}
        stroke-width={@stroke_width}
        stroke="currentColor"
        fill="transparent"
        r={@radius}
        cx={@center}
        cy={@center}
      />
      <circle
        class={@progress_circle_class}
        stroke-width={@stroke_width}
        stroke-dasharray={@circumference}
        stroke-dashoffset={@circumference - @progress / 100 * @circumference}
        stroke-linecap="round"
        stroke="currentColor"
        fill="transparent"
        r={@radius}
        cx={@center}
        cy={@center}
      />
    </svg>
    """
  end
end
