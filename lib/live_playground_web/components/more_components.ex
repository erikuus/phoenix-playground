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
  Renders a responsive multi-column layout which includes a left-fixed narrow sidebar.
  It has different types of menus adapted for various display sizes: a mobile menu for
  smaller displays and a desktop menu for larger screens.

  ## Example

      <.multi_column_layout>
        <:narrow_sidebar></:narrow_sidebar>
        <:mobile_menu></:mobile_menu>
        <:desktop_menu></:desktop_menu>
        <:slideouts></:slideouts>
        <%= @inner_content %>
      </.multi_column_layout>
  """
  attr :id, :string, default: "multi-column-layout"

  slot :narrow_sidebar, required: true
  slot :mobile_menu

  slot :desktop_menu do
    attr :hook, :string
  end

  slot :inner_block

  def multi_column_layout(assigns) do
    ~H"""
    <div
      class="fixed inset-y-0 flex flex-col pl-1.5 pr-1.5 py-1.5 space-y-1 items-center overflow-y-auto bg-zinc-700 w-14 md:w-20 z-20"
      role="complementary"
      aria-label="Sidebar"
    >
      {render_slot(@narrow_sidebar)}
    </div>
    <div :if={@mobile_menu != [] && @desktop_menu != []} class="pl-14 md:pl-20">
      <div id={"#{@id}-mobile-menu"} class="relative z-40 hidden" role="dialog" aria-modal="true" aria-label="Mobile Menu">
        <div class="fixed inset-0 bg-gray-600 bg-opacity-75" aria-hidden="true"></div>
        <div class="fixed inset-0 z-40 flex">
          <div class="relative flex w-full max-w-xs flex-1 flex-col bg-white" role="document">
            <div class="absolute top-0 right-0 -mr-12 pt-2">
              <button
                phx-click={JS.hide(to: "##{@id}-mobile-menu")}
                type="button"
                class="ml-1 flex h-10 w-10 items-center justify-center rounded-full focus:outline-none focus:ring-2 focus:ring-inset focus:ring-white"
                aria-label="Close sidebar"
              >
                <span class="sr-only">Close sidebar</span> <.icon name="hero-x-mark" class="h-6 w-6 text-white" />
              </button>
            </div>
            <div class="h-0 flex-1 overflow-y-auto p-2">
              <.focus_wrap
                id="mobile-sidebar-container"
                phx-window-keydown={JS.hide(to: "##{@id}-mobile-menu")}
                phx-key="escape"
                phx-click-away={JS.hide(to: "##{@id}-mobile-menu")}
              >
                {render_slot(@mobile_menu)}
              </.focus_wrap>
            </div>
          </div>
          <div class="w-14 flex-shrink-0" aria-hidden="true">
            <!-- Force sidebar to shrink to fit close icon -->
          </div>
        </div>
      </div>
      <div class="relative hidden lg:fixed lg:inset-y-0 lg:flex lg:flex-col" role="complementary" aria-label="Desktop Menu">
        <div class="flex min-h-0 flex-1 flex-col border-r border-gray-200 bg-white">
          <div
            :for={desktop_menu <- @desktop_menu}
            id={"#{@id}-desktop-menu-content"}
            phx-hook={Map.get(desktop_menu, :hook, nil)}
            class="flex flex-1 flex-col overflow-y-auto pb-4 lg:w-64"
            role="navigation"
          >
            {render_slot(desktop_menu)}
          </div>
        </div>
        <div
          phx-click={
            JS.toggle(to: "##{@id}-desktop-menu-content")
            |> JS.toggle_class("lg:pl-64", to: "##{@id}-main-container")
          }
          class="absolute inset-y-0 left-full cursor-pointer items-center px-2 flex group"
          title="Click to toggle sidebar"
          aria-label="Toggle sidebar"
        >
          <div class="h-6 w-1 rounded-full bg-gray-300 group-hover:bg-gray-400"></div>
        </div>
      </div>
      <div id={"#{@id}-main-container"} class="flex flex-1 flex-col lg:pl-64" role="main" aria-label="Main Content">
        <div class="sticky top-0 z-10 bg-white pl-2.5 pt-2 lg:hidden">
          <button
            phx-click={JS.show(to: "##{@id}-mobile-menu")}
            type="button"
            class="-mt-0.5 inline-flex h-12 w-12 items-center justify-center rounded-md text-gray-500 hover:text-gray-900 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-gray-100"
            aria-label="Open sidebar"
          >
            <span class="sr-only">Open sidebar</span> <.icon name="hero-bars-3" class="h-6 w-6" />
          </button>
        </div>
        <main class="flex-1">
          <div class="lg:px-3 lg:py-6">
            <div class="mx-auto max-w-7xl px-6">
              {render_slot(@inner_block)}
            </div>
          </div>
        </main>
      </div>
    </div>
    """
  end

  @doc """
  Renders a list of links to be displayed in a narrow sidebar.

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
      href={item.path}
      class={[
        "flex w-full flex-col items-center rounded-md p-3 text-xs font-medium",
        item.active == true && "bg-zinc-600 bg-opacity-50 text-white",
        item.active == false && "text-zinc-100 hover:bg-zinc-600 hover:bg-opacity-50 hover:text-white"
      ]}
      aria-label={item.label}
    >
      <.icon :if={item.icon} name={item.icon} class="h-6 w-6" /> <span class="mt-1 hidden md:block">{item.label}</span>
    </.link>
    """
  end

  @doc """
  Renders a vertical navigation structure that can be utilized in both desktop and mobile menus.

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
  attr :class, :string, default: nil
  attr :id, :string, required: true
  attr :items, :list, required: true

  def vertical_navigation(assigns) do
    ~H"""
    <nav class={["mt-4 bg-white space-y-1", @class]} aria-label="Vertical Navigation">
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
    <div class={["space-y-1", Map.has_key?(@item.section, :class) && @item.section.class]} role="group">
      <div class="ml-2 font-semibold leading-6 text-gray-500 text-xs">
        {@item.section.label}
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
      role="group"
      aria-labelledby={"#{@id}-#{@item.expandable.id}-label"}
    >
      <button
        phx-click={toggle_expandable("#{@id}-#{@item.expandable.id}")}
        type="button"
        class={["group flex items-center px-2 py-2 rounded-md text-sm w-full text-left", @item_class]}
        aria-expanded={@item.expandable.open}
        aria-controls={"#{@id}-#{@item.expandable.id}-content"}
        id={"#{@id}-#{@item.expandable.id}-label"}
      >
        <.icon
          :if={Map.has_key?(@item.expandable, :icon)}
          name={@item.expandable.icon}
          class="mr-1 flex-shrink-0 h-5 w-5 text-gray-500"
        />
        <span :if={Map.has_key?(@item.expandable, :label)} class="flex-1 ml-2">
          {@item.expandable.label}
        </span>
        <span
          :if={Map.has_key?(@item.expandable, :badge) && Map.has_key?(@item.expandable, :open)}
          class={[
            "mx-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full",
            @item.expandable.open == false && "bg-gray-100 group-hover:bg-gray-200",
            @item.expandable.open == true && "bg-gray-200"
          ]}
        >
          {@item.expandable.badge}
        </span>
        <.icon
          name="hero-chevron-right"
          class={[
            "mr-1 flex-shrink-0 h-3.5 w-3.5 text-gray-500",
            @item.expandable.open == true && "rotate-90"
          ]}
        />
      </button>
      <div id={"#{@id}-#{@item.expandable.id}-content"} class={["ver-nav-exp space-y-1", @item.expandable.open == false && "hidden"]}>
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
      aria-label={@item.label}
    >
      <.icon
        :if={Map.has_key?(@item, :icon) && Map.has_key?(@item, :active)}
        name={@item.icon}
        class="mr-1 flex-shrink-0 h-5 w-5 text-gray-500"
      />
      <span :if={Map.has_key?(@item, :label)} class="flex-1 ml-2">
        {@item.label}
      </span>
      <span
        :if={Map.has_key?(@item, :badge) && Map.has_key?(@item, :active)}
        class={[
          "ml-3 inline-block py-0.5 px-3 text-xs font-medium rounded-full",
          @item.active == false && "bg-gray-100 group-hover:bg-gray-200",
          @item.active == true && "bg-gray-200"
        ]}
      >
        {@item.badge}
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
  Renders a badge with different color themes.

  ## Examples

      <.badge>Badge</.badge>
      <.badge kind={:red}>Badge</.badge>
      <.badge kind={:yellow}>Badge</.badge>
  """
  attr :kind, :atom, default: :gray
  attr :class, :string, default: "text-xs font-medium px-2 py-1"
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span class={[
      "inline-flex items-center rounded-full ring-1 ring-inset",
      @kind == :gray && "bg-gray-50 text-gray-600 ring-gray-500/10",
      @kind == :red && "bg-red-50 text-red-700 ring-red-600/10",
      @kind == :yellow && "bg-yellow-50 text-yellow-800 ring-yellow-600/20",
      @kind == :green && "bg-green-50 text-green-700 ring-green-600/20",
      @kind == :blue && "bg-blue-50 text-blue-700 ring-blue-700/10",
      @kind == :indigo && "bg-indigo-50 text-indigo-700 ring-indigo-700/10",
      @kind == :purple && "bg-purple-50 text-purple-700 ring-purple-700/10",
      @kind == :pink && "bg-pink-50 text-pink-700 ring-pink-700/10",
      @class
    ]}>
      {render_slot(@inner_block)}
    </span>
    """
  end

  @doc """
  Renders a link that is designed to look like a button.

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
      role="button"
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  @doc """
  Renders a notification or alert box with specific types.

  # Simple alerts

      <.alert>Info</.alert>
      <.alert kind={:warning}>Warning</.alert>
      <.alert kind={:error}>Error</.alert>

  # Flash-based alert

  <.alert
    flash={@flash}
    flash_key={:breaking_news}
    title="Breaking News"
    icon="hero-exclamation-triangle-mini"
    kind={:error}
  />

  """
  attr :id, :string, default: "alert"
  attr :kind, :atom, default: :info
  attr :class, :string, default: "text-sm"
  attr :icon, :string, default: nil
  attr :title, :string, default: nil
  attr :close, :boolean, default: true
  attr :flash, :map, default: %{}
  attr :flash_key, :any, default: nil

  slot :inner_block

  def alert(assigns) do
    ~H"""
    <div
      :if={(@flash_key && Phoenix.Flash.get(@flash, @flash_key)) || !@flash_key}
      phx-click={
        if @flash_key do
          JS.push("lv:clear-flash", value: %{key: @flash_key})
        else
          hide("##{@id}")
        end
      }
      id={@id}
      class={[
        "rounded-md p-4",
        @kind == :info && "bg-zinc-100 text-zinc-600",
        @kind == :success && "bg-green-50 text-green-700",
        @kind == :warning && "bg-yellow-50 text-yellow-700",
        @kind == :error && "bg-red-50 text-red-700",
        @class
      ]}
      role="alert"
      aria-labelledby={"#{@id}-title"}
    >
      <div class="flex items-start">
        <div :if={@icon} class="flex-shrink-0">
          <.icon :if={@icon} name={@icon} />
        </div>

        <div class={["flex-1", @icon != nil && "ml-3"]}>
          <h3 :if={@title} id={"#{@id}-title"} class="font-medium mb-2">{@title}</h3>
          <p>
            <%= if @flash_key do %>
              {Phoenix.Flash.get(@flash, @flash_key)}
            <% else %>
              {render_slot(@inner_block)}
            <% end %>
          </p>
        </div>

        <button :if={@close} type="button" class="flex-shrink-0 ml-4" aria-label="Close alert">
          <.icon name="hero-x-mark-solid" class="w-5 h-5 opacity-40 group-hover:opacity-70" />
        </button>
      </div>
    </div>
    """
  end

  @doc """
  Renders a note as text within a card structure accompanied by an icon.

  ## Example

      <.note icon="hero-information-circle" class="mt-6">Content</.note>
  """
  attr :class, :string, default: nil
  attr :icon, :string, default: nil
  slot :inner_block, required: true

  def note(assigns) do
    ~H"""
    <div
      class={["flex flex-col sm:flex-row px-4 py-5 sm:p-6 overflow-hidden shadow-sm border border-gray-200 rounded-md ", @class]}
      role="note"
    >
      <div :if={@icon} class="flex-shrink-0">
        <.icon name={@icon} class="h-6 w-6" />
      </div>

      <div class="mt-3 sm:ml-3 sm:mt-0">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  @doc """
  Renders a basic list.

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
    <div class={@class} role="list">
      <dl class="divide-y divide-zinc-100">
        <div :for={item <- @item} class={["flex gap-4 py-4 sm:gap-8", Map.get(item, :class)]} role="listitem">
          {render_slot(item)}
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a list of steps.
  This list can be used as a menu or a simple text-based progress tracker.

  ## Examples

      <.steps>
        <:step :for={step <- @steps} path={step.path} active={step.active}>
          <%= step.name %>
        </:step>
      </.steps>

      <.steps>
        <:step active={true}>
          First
        </:step>
        <:step active={true}>
          Second
        </:step>
        <:step active={true}>
          Third
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
      <li :for={step <- @step} class="relative flex gap-x-2" role="listitem">
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
            {render_slot(step)}
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
            {render_slot(step)}
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
        <:tab :for={tab <- @tabs} patch={tab.path} active={tab.active}>
          <%= tab.name %>
        </:tab>
      </.tabs>
  """
  attr :id, :string, default: "tabs"
  attr :class, :string, default: nil

  attr :modifier, :string,
    default: nil,
    doc:
      "Tailwind modifier to set the screen breakpoint where tabs are displayed instead of a dropdown."

  slot :tab, required: true do
    attr :path, :any, required: true
    attr :active, :boolean
  end

  def tabs(assigns) do
    ~H"""
    <div
      class={[
        "border-b border-gray-200",
        @modifier && "hidden #{@modifier}:block",
        @class
      ]}
      role="tablist"
    >
      <nav class="-mb-px flex space-x-8 flex-wrap md:flex-nowrap">
        <.link
          :for={tab <- @tab}
          navigate={tab.path}
          class={[
            "whitespace-nowrap border-b-2 py-4 px-1 text-sm font-medium",
            tab.active == false && "border-transparent text-zinc-500 hover:border-zinc-300",
            tab.active == true && "border-zinc-500 text-zinc-700"
          ]}
          role="tab"
          aria-selected={tab.active}
        >
          {render_slot(tab)}
        </.link>
      </nav>
    </div>

    <div :if={@modifier} class={["block #{@modifier}:hidden", @class]} role="tabpanel">
      <button
        id={"#{@id}-open"}
        phx-click={JS.show(to: "##{@id}-dropdown") |> JS.hide(to: "##{@id}-open") |> JS.show(to: "##{@id}-close")}
        type="button"
        class="text-zinc-600 py-4 px-1 text-sm font-medium"
        aria-label="Open tabs"
      >
        <span class="sr-only">Open tabs</span> <.icon name="hero-ellipsis-vertical" class="h-6 w-6 text-zinc-600" />
      </button>
      <button
        id={"#{@id}-close"}
        type="button"
        phx-click={JS.hide(to: "##{@id}-dropdown") |> JS.hide(to: "##{@id}-close") |> JS.show(to: "##{@id}-open")}
        class="hidden text-zinc-600 py-4 px-1 text-sm font-medium"
        aria-label="Close tabs"
      >
        <span class="sr-only">Close tabs</span> <.icon name="hero-x-mark" class="h-6 w-6 text-zinc-600" />
      </button>

      <ul
        id={"#{@id}-dropdown"}
        phx-click-away={JS.hide(to: "##{@id}-dropdown") |> JS.hide(to: "##{@id}-close") |> JS.show(to: "##{@id}-open")}
        class="hidden absolute z-10 -mt-3 rounded-md shadow-lg py-1 border border-gray-200 bg-white"
        role="menu"
      >
        <li
          :for={tab <- @tab}
          class={[
            "relative",
            tab.active == false && "hover:bg-zinc-300",
            tab.active == true && "bg-zinc-500 text-white"
          ]}
          role="menuitem"
        >
          <.link navigate={tab.path} class="block py-2 px-8">
            {render_slot(tab)}
          </.link>
        </li>
      </ul>
    </div>
    """
  end

  @doc """
  Renders cards for displaying various statistics.
  Each card has its own title and content.

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
  </.stats>
  """
  attr :class, :string, default: nil

  slot :card, required: true do
    attr :title, :string, required: true
  end

  def stats(assigns) do
    ~H"""
    <dl class={["grid grid-cols-1 gap-5 sm:grid-cols-3 xl:grid-cols-4", @class]} role="list">
      <div
        :for={card <- @card}
        class="relative overflow-hidden rounded-lg shadow-sm border border-gray-200 bg-white px-4 py-5 sm:p-6"
        role="listitem"
      >
        <dt class="truncate text-sm font-medium text-gray-500">{card.title}</dt>
        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">
          {render_slot(card)}
        </dd>
      </div>
    </dl>
    """
  end

  @doc """
  Renders a spinning circle that serves as a loading indicator.

  ## Examples

      <.loading :if={@loading} />

      <.button>
        Search <.loading :if={@loading} class="ml-2 -mr-2 w-5 h-5" />
      </.button>
  """
  attr :class, :string, default: "w-6 h-6"

  def loading(assigns) do
    ~H"""
    <svg
      class={["animate-spin", @class]}
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      role="img"
      aria-label="Loading"
    >
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
  Renders a pagination toolbar component, allowing navigation through pages of items.

  This component displays 'Previous' and 'Next' navigation links along with direct links
  to individual pages based on the current page, items per page, and the total count of items.

  ## Features
    * Supports both event-based and URL-based (LiveView patches) navigation
    * Configurable URL parameters
    * Maintains existing query parameters
    * Handles options maps
    * Customizable styling

  ## Parameters

    * `:class` (optional) - Additional CSS classes to apply to the toolbar.
    * `:event` - The LiveView event to handle page changes (used when patch_path is not provided).
    * `:patch_path` (optional) - Base path for URL-based navigation.
    * `:page` - The current page number.
    * `:per_page` - Number of items per page.
    * `:count_all` - Total count of items across all pages.
    * `:limit` - Maximum number of page links to show around the current page.
    * `:params_key` (optional) - Key to use for page parameter in URL. Defaults to "page".
    * `:params_per_page_key` (optional) - Key to use for per_page parameter in URL. When nil, per_page is not included.
    * `:keep_params` (optional) - A map of parameters to maintain in the URL when navigating.
    * `:hook` (optional) - A LiveView JS hook name to attach to the pagination navigation.
      Useful for adding client-side behaviors like scrolling to top on page changes.

  ## Basic usage with event (no URL parameters):
      <.pagination
        event="paginate"
        page={@page}
        per_page={@per_page}
        count_all={@count}
      />

  ## Basic usage with only page parameter in URL:
      <.pagination
        patch_path="/items"
        page={@page}
        per_page={@per_page}
        count_all={@count}
      />
      # Results in: /items?page=2

  ## Including both page and per_page in URL:
      <.pagination
        patch_path="/items"
        page={@page}
        per_page={@per_page}
        count_all={@count}
        params_per_page_key="per_page"
      />
      # Results in: /items?page=2&per_page=10

  ## Using with options map and maintaining other parameters:
      # In your LiveView:
      @impl true
      def mount(_params, _session, socket) do
        options = %{
          page: 1,
          per_page: 5,
          sort: "name",
          filter: "active"
        }

        {:ok, assign(socket, options: options)}
      end

      # In your template:
      <.pagination
        patch_path="/items"
        page={@options.page}
        per_page={@options.per_page}
        count_all={@count}
        keep_params={Map.take(@options, [:sort, :filter])}
      />
      # Results in: /items?page=2&sort=name&filter=active

   ## Example with scroll-to-top hook:
      # In your app.js:
      let ScrollToTop = {
        updated() {
          window.scrollTo({ top: 0, behavior: "auto" });
        },
      };

      # In your template:
      <.pagination
        patch_path="/items"
        page={@page}
        per_page={@per_page}
        count_all={@count}
        hook="ScrollToTop"
      />
  """
  attr :id, :string, default: "pagination"
  attr :class, :string, default: nil
  attr :event, :string, default: nil
  attr :patch_path, :string, default: nil
  attr :page, :integer, required: true
  attr :per_page, :integer, required: true
  attr :count_all, :integer, required: true
  attr :params_key, :string, default: "page"
  attr :params_per_page_key, :string, default: nil
  attr :keep_params, :map, default: %{}
  attr :hook, :string, default: nil

  attr :limit, :integer,
    default: 5,
    doc: "The maximum number of page links displayed to the left and right of the current page."

  attr :modifier, :string,
    default: nil,
    doc: "Tailwind modifier to define the screen breakpoint for displaying page links."

  def pagination(assigns) do
    assigns =
      assign_new(assigns, :use_patch?, fn ->
        not is_nil(assigns[:patch_path])
      end)

    ~H"""
    <nav
      :if={@count_all > 0}
      id={@id}
      phx-hook={@hook}
      data-current-page={@page}
      class={["flex items-center justify-between border-t border-gray-200 px-4 sm:px-0", @class]}
      aria-label="Pagination"
    >
      <div class="-mt-px flex w-0 flex-1 flex-shrink-0">
        <%= if @page > 1 do %>
          <%= if @use_patch? do %>
            <.link
              patch={build_pagination_path(@patch_path, @page - 1, @per_page, @params_key, @params_per_page_key, @keep_params)}
              class={[
                "inline-flex items-center border-t-2 pt-4 text-sm font-medium pr-4",
                "border-transparent text-zinc-500 hover:border-zinc-300"
              ]}
              aria-label="Previous page"
            >
              <.icon name="hero-arrow-long-left" class="mr-3 h-5 w-5 text-gray-500" /> Previous
            </.link>
          <% else %>
            <.link
              phx-click={@event}
              phx-value-page={@page - 1}
              class={[
                "inline-flex items-center border-t-2 pt-4 text-sm font-medium pr-4",
                "border-transparent text-zinc-500 hover:border-zinc-300"
              ]}
              aria-label="Previous page"
            >
              <.icon name="hero-arrow-long-left" class="mr-3 h-5 w-5 text-gray-500" /> Previous
            </.link>
          <% end %>
        <% end %>
      </div>

      <div class={[
        "flex flex-nowrap overflow-x-hidden mx-24",
        @modifier && "hidden #{@modifier}:-mt-px #{@modifier}:flex"
      ]}>
        <%= for page <- get_pages(@page, @per_page, @count_all, @limit) do %>
          <%= if @page == page do %>
            <span
              class="inline-flex items-center border-t-2 pt-4 text-sm font-bold px-4 border-zinc-500 text-zinc-600"
              aria-current="page"
            >
              {page}
            </span>
          <% else %>
            <%= if @use_patch? do %>
              <.link
                patch={build_pagination_path(@patch_path, page, @per_page, @params_key, @params_per_page_key, @keep_params)}
                class="inline-flex items-center border-t-2 pt-4 text-sm font-medium px-4 border-transparent text-zinc-500 hover:border-zinc-300"
                aria-label={"Page #{page}"}
              >
                {page}
              </.link>
            <% else %>
              <.link
                phx-click={@event}
                phx-value-page={page}
                class="inline-flex items-center border-t-2 pt-4 text-sm font-medium px-4 border-transparent text-zinc-500 hover:border-zinc-300"
                aria-label={"Page #{page}"}
              >
                {page}
              </.link>
            <% end %>
          <% end %>
        <% end %>
      </div>

      <div class="-mt-px flex w-0 flex-1 justify-end flex-shrink-0">
        <%= if @page * @per_page < @count_all do %>
          <%= if @use_patch? do %>
            <.link
              patch={build_pagination_path(@patch_path, @page + 1, @per_page, @params_key, @params_per_page_key, @keep_params)}
              class={[
                "inline-flex items-center border-t-2 pt-4 text-sm font-medium pl-4",
                "border-transparent text-zinc-500 hover:border-zinc-300"
              ]}
              aria-label="Next page"
            >
              Next <.icon name="hero-arrow-long-right" class="ml-3 h-5 w-5 text-gray-500" />
            </.link>
          <% else %>
            <.link
              phx-click={@event}
              phx-value-page={@page + 1}
              class={[
                "inline-flex items-center border-t-2 pt-4 text-sm font-medium pl-4",
                "border-transparent text-zinc-500 hover:border-zinc-300"
              ]}
              aria-label="Next page"
            >
              Next <.icon name="hero-arrow-long-right" class="ml-3 h-5 w-5 text-gray-500" />
            </.link>
          <% end %>
        <% end %>
      </div>
    </nav>
    """
  end

  defp get_pages(page, per_page, count_all, limit) do
    page_count = div(count_all + per_page - 1, per_page)
    Enum.filter((page - limit)..(page + limit), &(&1 > 0 and &1 <= page_count))
  end

  defp build_pagination_path(
         base_path,
         page,
         per_page,
         params_key,
         params_per_page_key,
         keep_params
       ) do
    params = Map.put(keep_params, params_key, page)

    params =
      if params_per_page_key do
        Map.put(params, params_per_page_key, per_page)
      else
        params
      end

    query_string = URI.encode_query(params)
    "#{base_path}?#{query_string}"
  end

  @doc """
  Renders an editable content.

  The editable field is composed of two blocks: (1) an inner block that displays the content and includes an edit link,
  and (2) a block that contains input fields with save and cancel buttons. The actions associated with the edit link,
  save and cancel buttons are triggered by events that should be defined in the liveview that renders this component.

  ## Example

      <.editable
        save_event="nosave"
        edit_event="edit"
        cancel_event="cancel"
        id="lastname"
        form={@form}
        edit={@edit_field == "lastname"}
      >
        <%= @person.lastname %>
        <:input_block>
          <.input field={@form[:lastname]} type="text" class="flex-auto md:-ml-3" />
        </:input_block>
      </.editable>
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
    <div :if={!@edit} class="w-full flex items-center justify-between" role="region" aria-label="Editable Content">
      <div id={@id}>
        {render_slot(@inner_block)}
      </div>

      <.link phx-click={@edit_event} phx-value-field={@id} aria-label="Edit">
        <span class="hidden md:inline font-bold">Edit</span>
        <.icon name="hero-pencil-square-mini" class="md:hidden h-6 w-6" />
      </.link>
    </div>

    <.form
      :if={@edit}
      for={@form}
      phx-submit={@save_event}
      class="flex flex-col space-x-0 space-y-2 md:flex-row md:space-x-2 md:space-y-0"
      aria-label="Edit Form"
    >
      {render_slot(@input_block)}
      <div>
        <.button class="w-full md:w-auto" phx-disable-with="">Save</.button>
      </div>

      <div>
        <.button_link kind={:secondary} class="w-full md:w-auto" phx-click={@cancel_event}>Cancel</.button_link>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a slideover - a UI panel that slides in from the right edge to overlay existing content.

  ## Examples

      # Basic usage with content:
      <.slideover id="menu">
        Menu content here
      </.slideover>

      # Advanced usage with custom button actions:
      <.slideover id="confirm"
        on_confirm={JS.push("delete")}
        on_cancel={JS.navigate(~p"/items")}>
        Are you sure you want to delete these items?
        <:confirm>Delete</:confirm>
        <:cancel>Go Back</:cancel>
      </.slideover>

      # To trigger the slideover, use a button with phx-click:
      <.button_link phx-click={show_slideover("menu")}>
        Open Menu
      </.button_link>
  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}
  attr :width_class, :string, default: "max-w-md"
  attr :enable_main_content, :boolean, default: false

  slot :inner_block, required: true
  slot :title
  slot :subtitle

  slot :confirm do
    attr :class, :string
  end

  slot :cancel

  def slideover(assigns) do
    ~H"""
    <div class="relative z-40" aria-labelledby={"#{@id}-title"} role="dialog" aria-modal="true" tabindex="0">
      <div
        :if={!@enable_main_content}
        id={"#{@id}-bg"}
        class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity hidden"
        aria-hidden="true"
      />
      <div
        id={@id}
        phx-mounted={@show && show_slideover(@id)}
        phx-remove={hide_slideover(@id)}
        class={["fixed inset-0 overflow-hidden hidden", @enable_main_content && "w-0"]}
      >
        <div class="absolute inset-0 overflow-hidden">
          <div class="pointer-events-none fixed inset-y-0 right-0 flex max-w-full pl-10">
            <div class={["pointer-events-auto w-screen", @width_class]}>
              <.focus_wrap
                id={"#{@id}-container"}
                phx-mounted={@show && show_slideover(@id)}
                phx-window-keydown={!@enable_main_content && hide_slideover(@on_cancel, @id)}
                phx-key="escape"
                phx-click-away={!@enable_main_content && hide_slideover(@on_cancel, @id)}
                class="flex h-full flex-col bg-white py-6 shadow px-4 sm:px-6"
              >
                <div class="flex items-start justify-between">
                  <header>
                    <h3 id={"#{@id}-title"} class="text-xl font-medium leading-6 text-gray-900">
                      {render_slot(@title)}
                    </h3>

                    <p :if={@subtitle != []} id={"#{@id}-subtitle"} class="mt-2 text-base leading-6 text-zinc-600">
                      {render_slot(@subtitle)}
                    </p>
                  </header>

                  <div class="ml-3 flex h-7">
                    <.link phx-click={hide_slideover(@on_cancel, @id)} aria-label="Close">
                      <.icon name="hero-x-mark-solid" class="w-6 h-6 text-gray-400 hover:text-gray-500" />
                    </.link>
                  </div>
                </div>

                <div class="relative mt-6 flex-1 overflow-y-auto">
                  {render_slot(@inner_block)}
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
                    aria-label="Cancel"
                  >
                    {render_slot(cancel)}
                  </.link>

                  <.button
                    :for={confirm <- @confirm}
                    phx-click={@on_confirm}
                    id={"#{@id}-confirm"}
                    phx-disable-with
                    class={"w-full sm:w-auto mt-3 sm:mt-0 #{Map.get(confirm, :class, nil)}"}
                    aria-label="Confirm"
                  >
                    {render_slot(confirm)}
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

  def show_slideover(js \\ %JS{}, id, enable_main_content \\ false) when is_binary(id) do
    js
    |> JS.show(
      to: "##{id}",
      transition: {
        "ease-in-out",
        "translate-x-full",
        "translate-x-0"
      }
    )
    |> JS.show(
      to: "##{id}-bg",
      transition: "fade-in"
    )
    |> handle_main_content(enable_main_content)
    |> JS.focus_first(to: "##{id}-container")
  end

  defp handle_main_content(js, true), do: js

  defp handle_main_content(js, false) do
    js
    |> JS.add_class("overflow-y-hidden", to: "#root-body")
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
        "ease-in-out",
        "translate-x-0",
        "translate-x-full"
      }
    )
    |> JS.remove_class("overflow-y-hidden", to: "#root-body")
    |> JS.pop_focus()
  end

  @doc """
  Renders a file upload area.

  Users can upload files by either clicking on the area to open the file selector or by dragging
  and dropping files into the dashed rectangle. It supports uploading multiple files simultaneously.

  ## Example

      <.uploads_upload_area uploads_name={@uploads.photos} />
  """
  attr :uploads_name, :map, required: true

  def uploads_upload_area(assigns) do
    ~H"""
    <div
      phx-drop-target={@uploads_name.ref}
      class="flex justify-center rounded-lg border border-dashed border-zinc-900/25 px-6 py-10"
      role="region"
      aria-label="File Upload Area"
    >
      <div class="text-center">
        <.icon name="hero-photo" class="mx-auto h-12 w-12 text-zinc-300" />
        <div class="mt-4 flex text-sm leading-6 text-zinc-600">
          <label for={@uploads_name.ref} class="relative cursor-pointer bg-transparent font-semibold">
            <span>Upload a file</span>
            <.live_file_input upload={@uploads_name} class="sr-only" />
          </label>

          <p class="pl-1">or drag and drop</p>
        </div>

        <p class="text-xs leading-5 text-zinc-600">
          {@uploads_name.max_entries} {format_uploads_accept(@uploads_name.accept)} files up to {trunc(
            @uploads_name.max_file_size / 1_000_000
          )} MB each
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
  Renders a preview area designated for image uploads.

  The photo preview area displays thumbnails of the images, offering a visual confirmation of the files
  selected. Thumbnails of uploaded files are displayed instantly for review. Users can interact with
  individual thumbnails to remove the files before the final upload.

  ## Example

      <.uploads_photo_preview_area uploads_name={@uploads.photos} />
  """
  attr :uploads_name, :map, required: true
  attr :target, :string, default: nil

  def uploads_photo_preview_area(assigns) do
    ~H"""
    <ul role="list" class="grid grid-cols-2 gap-x-4 gap-y-8 sm:grid-cols-3 sm:gap-x-6 xl:grid-cols-4">
      <li :for={entry <- @uploads_name.entries} role="listitem">
        <.live_img_preview
          :if={:not_accepted not in upload_errors(@uploads_name, entry)}
          entry={entry}
          class="object-contain w-full h-28 sm:h-44 rounded-lg bg-zinc-200"
          aria-label="Image preview"
        />
        <div
          :if={:not_accepted in upload_errors(@uploads_name, entry)}
          class="flex items-center justify-center text-xs w-full h-28 sm:h-44 rounded-lg bg-zinc-100 text-ellipsis truncate"
          aria-label="File not accepted"
        >
          {entry.client_name}
        </div>

        <div class="flex justify-between items-center space-x-2">
          <div :if={upload_errors(@uploads_name, entry) == []} class="mt-3 flex gap-3 text-sm leading-6">
            <.circular_progress_bar progress={entry.progress} stroke_width={3} radius={7.5} svg_class="mt-0.5 w-5 h-5 flex-none" />
            <div :if={entry.progress > 0} aria-label="Upload progress">
              {entry.progress}%
            </div>
          </div>

          <.error :for={err <- upload_errors(@uploads_name, entry)}>
            {Phoenix.Naming.humanize(err)}
          </.error>

          <.link phx-click="cancel" phx-value-ref={entry.ref} phx-target={@target} class="mt-2" aria-label="Cancel upload">
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
      |> assign_new(:circumference, fn -> 2 * :math.pi() * assigns.radius end)

    ~H"""
    <svg class={@svg_class} role="img" aria-label="Progress">
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
