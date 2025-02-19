defmodule LivePlaygroundWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  The components in this module use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn how to
  customize the generated components in this module.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Phoenix.Component

  use Gettext, backend: LivePlaygroundWeb.Gettext

  alias Phoenix.LiveView.JS

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        Are you sure?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>

  JS commands may be passed to the `:on_cancel` and `on_confirm` attributes
  for the caller to react to each button press, for example:

      <.modal id="confirm" on_confirm={JS.push("delete")} on_cancel={JS.navigate(~p"/posts")}>
        Are you sure you?
        <:confirm>OK</:confirm>
        <:cancel>Cancel</:cancel>
      </.modal>
  """
  attr :id, :string, required: true
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}
  attr :width_class, :string, default: "sm:max-w-lg"

  slot :inner_block, required: true
  slot :icon
  slot :title
  slot :subtitle

  slot :confirm do
    attr :class, :string
  end

  slot :cancel

  def modal(assigns) do
    ~H"""
    <div id={@id} phx-mounted={@show && show_modal(@id)} phx-remove={hide_modal(@id)} class="relative z-50 hidden">
      <div id={"#{@id}-bg"} class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true" />
      <div class="fixed inset-0 overflow-y-auto" aria-labelledby={"#{@id}-title"} role="dialog" aria-modal="true" tabindex="0">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
          <div class="relative overflow-hidden rounded-lg bg-white text-left shadow-xl sm:my-8 sm:p-0">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-mounted={@show && show_modal(@id)}
              phx-window-keydown={hide_modal(@on_cancel, @id)}
              phx-key="escape"
              phx-click-away={hide_modal(@on_cancel, @id)}
            >
              <div class="absolute top-0 right-0 hidden pt-4 pr-4 sm:block">
                <.link phx-click={hide_modal(@on_cancel, @id)} aria-label="Close">
                  <.icon name="hero-x-mark-solid" class="w-6 h-6 text-gray-400 hover:text-gray-500" />
                </.link>
              </div>

              <div id={"#{@id}-content"}>
                <div class={["p-4 sm:p-6 sm:w-full sm:min-w-[400px]", @width_class]}>
                  <div class="sm:flex sm:items-start">
                    <div
                      :if={@icon != []}
                      class="mx-auto flex h-12 w-12 flex-shrink-0 items-center justify-center sm:mx-0 sm:h-10 sm:w-10 sm:mr-4"
                    >
                      {render_slot(@icon)}
                    </div>

                    <div class="mt-3 text-center sm:mt-0 sm:text-left">
                      <header :if={@title != []}>
                        <h3 id={"#{@id}-title"} class="text-lg font-medium leading-6 text-gray-900">
                          {render_slot(@title)}
                        </h3>

                        <p :if={@subtitle != []} id={"#{@id}-subtitle"} class="mt-2 text-base leading-6 text-zinc-600">
                          {render_slot(@subtitle)}
                        </p>
                      </header>

                      <div class="mt-2">
                        <p class="text-sm text-gray-500">
                          {render_slot(@inner_block)}
                        </p>
                      </div>
                    </div>
                  </div>

                  <div :if={@confirm != [] or @cancel != []} class="mt-5 sm:mt-4 sm:ml-10 sm:pl-4 sm:flex sm:flex-row-reverse">
                    <.link
                      :for={cancel <- @cancel}
                      phx-click={hide_modal(@on_cancel, @id)}
                      class={[
                        "inline-flex items-center justify-center rounded-lg border border-zinc-200 bg-zinc-100 hover:bg-zinc-200",
                        "py-2 px-5 text-sm font-semibold leading-6 text-gray-700 active:text-gray-800",
                        "w-full sm:w-auto sm:ml-3"
                      ]}
                    >
                      {render_slot(cancel)}
                    </.link>

                    <.button
                      :for={confirm <- @confirm}
                      phx-click={@on_confirm}
                      id={"#{@id}-confirm"}
                      phx-disable-with
                      class={"w-full sm:w-auto mt-3 sm:mt-0 #{Map.get(confirm, :class, nil)}"}
                    >
                      {render_slot(confirm)}
                    </.button>
                  </div>
                </div>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, default: "flash", doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :autoshow, :boolean, default: true, doc: "whether to auto show the flash on mount"
  attr :close, :boolean, default: true, doc: "whether the flash can be closed"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-mounted={@autoshow && show("##{@id}")}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed hidden top-2 right-2 mr-3 mt-3 w-80 sm:w-96 z-50 rounded-lg px-4 py-3 shadow-md shadow-zinc-900/5 ring-1",
        @kind == :info &&
          "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error &&
          "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <div class="flex items-start">
        <div class="flex-1">
          <p :if={@title} class="flex items-center gap-1.5 text-[0.8125rem] font-semibold leading-6">
            <.icon :if={@kind == :info} name="hero-information-circle-mini" class="w-4 h-4" />
            <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="w-4 h-4" /> {@title}
          </p>

          <p class={["text-[0.8125rem] leading-5", @title != nil && "mt-2"]}>{msg}</p>
        </div>

        <button :if={@close} type="button" class="flex-shrink-0 ml-4" aria-label={gettext("close")}>
          <.icon name="hero-x-mark-solid" class="w-5 h-5 opacity-40 group-hover:opacity-70" />
        </button>
      </div>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  def flash_group(assigns) do
    ~H"""
    <.flash kind={:info} flash={@flash} />
    <.flash kind={:error} flash={@flash} />
    <.flash
      id="disconnected"
      kind={:error}
      title="We can't find the internet"
      close={false}
      autoshow={false}
      phx-disconnected={show("#disconnected")}
      phx-connected={hide("#disconnected")}
    >
      Attempting to reconnect <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
    </.flash>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the datastructure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="space-y-8 bg-white mt-10">
        {render_slot(@inner_block, f)}
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          {render_slot(action, f)}
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :kind, :atom, default: :primary
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75",
        "inline-flex items-center justify-center rounded-lg py-2 px-5 ring-inset",
        "text-sm font-semibold leading-6",
        @kind == :primary && "bg-zinc-900 hover:bg-zinc-700 text-white active:text-white/80",
        @kind == :secondary && "border border-zinc-200 bg-zinc-100 hover:bg-zinc-200 text-gray-700 active:text-gray-800",
        @kind == :dangerous && "bg-red-600 hover:bg-red-700 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `%Phoenix.HTML.Form{}` and field name may be passed to the input
  to build input names and error messages, or all the attributes and
  errors may be passed explicitly.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :class, :string, default: nil, doc: "the class name for container div"

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :rest, :global, include: ~w(autocomplete cols disabled form max maxlength min minlength
                                   pattern placeholder readonly required rows size step list)

  slot :inner_block

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox", value: value} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn -> Phoenix.HTML.Form.normalize_value("checkbox", value) end)

    ~H"""
    <div phx-feedback-for={@name} class={@class}>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input type="hidden" name={@name} value="false" />
        <input
          type="checkbox"
          id={@id || @name}
          name={@name}
          value="true"
          checked={@checked}
          class="rounded border-zinc-300 text-zinc-900 focus:ring-zinc-900"
          {@rest}
        /> {@label}
      </label>

      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={@class}>
      <.label :if={@label} for={@id}>{@label}</.label>

      <select
        id={@id}
        name={@name}
        class={[
          "block w-full rounded-lg border-zinc-300 py-2 pl-3 pr-8",
          "text-zinc-900 focus:outline-none focus:ring-4 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400 phx-no-feedback:focus:ring-zinc-800/5",
          "border-zinc-300 focus:border-zinc-400 focus:ring-zinc-800/5",
          @errors != [] &&
            "border-rose-400 focus:border-rose-400 focus:ring-rose-400/10"
        ]}
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value="">{@prompt}</option>
        {Phoenix.HTML.Form.options_for_select(@options, @value)}
      </select>

      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={@class}>
      <.label :if={@label} for={@id}>{@label}</.label>
      <textarea
        id={@id || @name}
        name={@name}
        class={[
          "block min-h-[6rem] w-full rounded-lg border-zinc-300 py-2 px-3",
          "text-zinc-900 focus:border-zinc-400 focus:outline-none focus:ring-4 focus:ring-zinc-800/5 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400 phx-no-feedback:focus:ring-zinc-800/5",
          "border-zinc-300 focus:border-zinc-400 focus:ring-zinc-800/5",
          @errors != [] &&
            "border-rose-400 focus:border-rose-400 focus:ring-rose-400/10"
        ]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(%{type: "radio"} = assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={@class}>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input
          type="radio"
          id={@id || @name}
          name={@name}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          checked={@checked}
          class="border-zinc-300 text-zinc-900 focus:ring-zinc-900"
          {@rest}
        /> {@label}
      </label>

      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div phx-feedback-for={@name} class={@class}>
      <.label :if={@label} for={@id}>{@label}</.label>

      <input
        type={@type}
        name={@name}
        id={@id || @name}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "block w-full rounded-lg border-zinc-300 py-2 px-3",
          "text-zinc-900 focus:outline-none focus:ring-4 sm:text-sm sm:leading-6",
          "phx-no-feedback:border-zinc-300 phx-no-feedback:focus:border-zinc-400 phx-no-feedback:focus:ring-zinc-800/5",
          "border-zinc-300 focus:border-zinc-400 focus:ring-zinc-800/5 disabled:bg-zinc-100",
          @errors != [] &&
            "border-rose-400 focus:border-rose-400 focus:ring-rose-400/10"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}>{msg}</.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-semibold leading-6 text-zinc-800 mb-2">
      {render_slot(@inner_block)}
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="phx-no-feedback:hidden mt-3 flex gap-3 text-sm leading-6 text-rose-600">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 w-5 h-5 flex-none" /> {render_slot(@inner_block)}
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true

  slot :subtitle do
    attr :class, :string
  end

  slot :actions do
    attr :class, :string
  end

  def header(assigns) do
    ~H"""
    <header class={[
      @actions != [] && "md:flex md:items-center md:justify-between",
      @class
    ]}>
      <div class="min-w-0 flex-1">
        <h1 class="text-3xl font-bold leading-8 text-zinc-800">
          {render_slot(@inner_block)}
        </h1>

        <p :for={subtitle <- @subtitle} class={["mt-2 mr-4 text-sm leading-6 text-zinc-600", Map.get(subtitle, :class, nil)]}>
          {render_slot(@subtitle)}
        </p>
      </div>

      <div :for={actions <- @actions} class={["mt-4 flex md:mt-0 md:ml-4 self-start", Map.get(actions, :class, nil)]}>
        {render_slot(@actions)}
      </div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :class, :string, default: "mt-11 w-full"
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"
  attr :row_class, :any, default: nil, doc: "the function for handling class on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
    attr :class, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <table class={@class}>
      <thead class="text-left text-[0.8125rem] leading-6 text-zinc-500">
        <tr>
          <th :for={col <- @col} class={["p-0 pb-4 font-normal", col[:class]]}>
            {col[:label]}
          </th>

          <th class="relative p-0 pb-4">
            <span class="sr-only">{gettext("Actions")}</span>
          </th>
        </tr>
      </thead>

      <tbody
        id={@id}
        phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
        class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700"
      >
        <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group hover:bg-zinc-50">
          <td
            :for={{col, i} <- Enum.with_index(@col)}
            phx-click={@row_click && @row_click.(row)}
            class={["relative p-0", col[:class], @row_click && "hover:cursor-pointer", @row_class && @row_class.(row)]}
          >
            <div class="block py-4">
              <span class={[
                "absolute -inset-y-px right-0 -left-4 group-hover:bg-zinc-50 sm:rounded-l-lg",
                @row_class && @row_class.(row)
              ]} />
              <span
                :if={@action == []}
                class={[
                  "absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 sm:rounded-r-lg",
                  @row_class && @row_class.(row)
                ]}
              />
              <span class={["relative", i == 0 && "font-semibold text-zinc-900"]}>
                {render_slot(col, @row_item.(row))}
              </span>
            </div>
          </td>

          <td :if={@action != []} class="relative p-0 w-14">
            <div class="block whitespace-nowrap py-4 text-right text-sm font-medium">
              <span class={[
                "absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 sm:rounded-r-lg",
                @row_class && @row_class.(row)
              ]} />
              <span :for={action <- @action} class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700">
                {render_slot(action, @row_item.(row))}
              </span>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  attr :class, :string, default: "mt-14"

  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class={@class}>
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="md:flex py-4 sm:gap-8">
          <dt class="md:w-1/4 md:flex-none text-[0.8125rem] leading-6 text-zinc-500">
            {item.title}
          </dt>
          <dd class="text-sm leading-6 text-zinc-700 w-full">{render_slot(item)}</dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link navigate={@navigate} class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700">
        <.icon name="hero-arrow-left-solid" class="w-3 h-3" /> {render_slot(@inner_block)}
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Hero Icon](https://heroicons.com).

  Hero icons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid an mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from your `priv/hero_icons` directory and bundled
  within your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-cake" />
      <.icon name="hero-cake-solid" />
      <.icon name="hero-cake-mini" />
      <.icon name="hero-bolt" class="bg-blue-500 w-10 h-10" />
  """
  attr :name, :string, required: true
  attr :class, :any, default: nil
  attr :id, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} id={@id} />
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      transition: "fade-in"
    )
    |> show("##{id}-container")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: "fade-out"
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(LivePlaygroundWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(LivePlaygroundWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
