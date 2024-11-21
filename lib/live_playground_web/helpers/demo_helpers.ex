defmodule LivePlaygroundWeb.DemoHelpers do
  @moduledoc """
  Provides specialized components and utility functions for enhancing the functionality within the playground.
  """
  import Phoenix.HTML
  import LivePlaygroundWeb.FileHelpers
  import LivePlaygroundWeb.CoreComponents
  import LivePlaygroundWeb.MoreComponents

  alias Phoenix.LiveView.JS

  use Phoenix.Component

  @doc """
  Creates a resizable iframe component for a LiveView with designated resize hook.

  ## Attributes
    - `:id` (String): DOM ID of the iframe, required.
    - `:src` (String): Source URL of the iframe content, required.
    - `:hook` (String): Name of the JavaScript hook to handle resizing, required.
    - `:height` (String): Initial height of the iframe, default is "h-96".

  ## Example
      <.resizable_iframe id="my_iframe" src="https://www.example.com" hook="IframeResize" />
  """
  attr :id, :string, required: true
  attr :src, :string, required: true
  attr :hook, :string, required: true
  attr :height, :string, default: "h-96"

  def resizable_iframe(assigns) do
    ~H"""
    <div id={"#{@id}-ruler"} class="w-full"></div>
    <div id={"#{@id}-container"} class="relative">
      <div id={"#{@id}-overlay"} class={[@height, "iframe-overlay absolute w-full overflow-hidden"]}></div>
      <iframe
        class={[@height, "w-full h-96 overflow-hidden rounded-lg ring-1 ring-slate-900/10"]}
        src={@src}
        aria-label="Resizable Frame"
      >
      </iframe>
      <div
        id={"#{@id}-handler"}
        data-ruler={"#{@id}-ruler"}
        data-container={"#{@id}-container"}
        data-overlay={"#{@id}-overlay"}
        phx-hook={@hook}
        class="absolute inset-y-0 left-full hidden cursor-ew-resize items-center px-2 sm:flex group"
        title="Drag to adjust size"
        aria-label="Resize handler"
        role="slider"
      >
        <div class="h-6 w-1 rounded-full bg-gray-300 group-hover:bg-gray-400"></div>
        <span class="hidden 2xl:inline ml-2 w-16 text-gray-500 text-xs group-hover:hidden">
          Drag to adjust size
        </span>
      </div>
    </div>
    """
  end

  @doc """
  Renders a link to a specific GitHub file, enhancing traceability of source code in demos.

  ## Attributes
    - `:filename` (String): Relative path to the file in the GitHub repository, required.

  ## Content
    - `:inner_block` (Slot): Customizable inner content for the link.

  ## Example
      <.github_link filename="lib/live_playground_web/components/more_components.ex">
        See more components source file
      </.github_link>
  """
  attr :filename, :string, required: true
  slot :inner_block, required: true

  def github_link(assigns) do
    assigns =
      assigns
      |> assign_new(:url, fn ->
        "https://github.com/erikuus/phoenix-playground/tree/main/#{Path.dirname(assigns.filename)}/#{Path.basename(assigns.filename)}"
      end)

    ~H"""
    <a target="_blank" class="underline" href={@url} aria-label="GitHub link"><%= render_slot(@inner_block) %></a>
    """
  end

  @doc """
  Provides a GitHub link that directs to a specific function definition within a source file.

  ## Attributes
    - `:filename` (String): Path to the file, required.
    - `:definition` (String): Name of the function to highlight, required.

  ## Content
    - `:inner_block` (Slot): Text or elements displayed within the link.

  ## Example
      <.goto_definition filename="..." definition="defp example_function">
        Go to function definition
      </.goto_definition>
  """
  attr :filename, :string, required: true
  attr :definition, :string, required: true
  slot :inner_block, required: true

  def goto_definition(assigns) do
    ~H"""
    <a
      class="flex items-center font-medium"
      target="_blank"
      href={"#{github_url(assigns.filename)}#:~:text=#{@definition}"}
      aria-label="Go to function definition"
    >
      <span><%= render_slot(@inner_block) %></span>
      <.icon name="hero-arrow-top-right-on-square" class="ml-1 w-5 h-5" />
    </a>
    """
  end

  @doc """
  Displays a link that opens a slideout.

  ## Example
      <.slideout_link target_id="mycode-breakdown" />
  """
  attr :title, :string, required: true
  attr :slideout_id, :string, required: true
  attr :main_container_id, :string, default: "multi-column-layout-main-container"

  def slideout_link(assigns) do
    ~H"""
    <.link
      id={"open-#{@slideout_id}"}
      class="slideout-link flex items-center font-medium"
      phx-click={
        show_slideover(
          JS.add_class("xl:pr-96 2xl:pr-[36rem] ease-in-out duration-200",
            to: "##{@main_container_id}"
          )
          |> hide(".slideout-link"),
          @slideout_id,
          true
        )
      }
      aria-label="Open slideout"
    >
      <span><%= @title %></span>
      <.icon name="hero-arrow-left-on-rectangle" class="ml-1 w-5 h-5" />
    </.link>
    """
  end

  @doc """
  Renders a slideout panel component used for displaying code breakdowns and additional documentation.
  The slideout is a UI element that appears from the side of the screen when triggered.

  ## Example
      <.slideout id="code-breakdown" filename="..." />
  """
  attr :title, :string, required: true
  attr :filename, :string, required: true
  attr :id, :string, required: true
  attr :main_container_id, :string, default: "multi-column-layout-main-container"

  def slideout(assigns) do
    assigns = assigns |> assign_new(:html_code, fn -> read_file(assigns.filename) |> raw() end)

    ~H"""
    <.slideover
      id={@id}
      enable_main_content={true}
      width_class="w-96 2xl:w-[36rem]"
      on_cancel={JS.remove_class("xl:pr-96 2xl:pr-[36rem]", to: "##{@main_container_id}") |> show(".slideout-link")}
    >
      <:title><%= @title %></:title>
      <div class="mr-2 prose prose-sm">
        <%= @html_code %>
      </div>
    </.slideover>
    """
  end

  @doc """
  Displays a code block from a specified file with optional highlighting from a start to an end marker.

  ## Attributes
    - `:filename` (String): Path to the source file, required.
    - `:from` (String): Start marker for code highlight.
    - `:to` (String): End marker for code highlight.
    - `:elixir` (Boolean): Flag to enable Elixir-specific highlighting, defaults to true.

  ## Examples
      <.code_block filename="..." />
      <.code_block filename="..." from="# start" to="# end" />
  """
  attr :filename, :string, required: true
  attr :from, :string
  attr :to, :string
  attr :elixir, :boolean

  def code_block(%{filename: filename, from: from, to: to} = assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> String.replace(assigns.filename, "/", "-") end)
      |> assign_new(:highlighted_code, fn ->
        read_file(filename)
        |> show_marked(from, to, Map.get(assigns, :elixir, true))
        |> hide_marked()
        |> Makeup.highlight()
        |> raw()
      end)

    ~H"""
    <div class="rounded-lg bg-[#f9f9f9] border border-gray-200 text-xs xl:text-sm" aria-label="Code block">
      <div class="flex justify-between items-center px-4 py-3 sm:px-6 text-gray-500">
        <div class="overflow-hidden text-ellipsis font-mono">
          <%= responsive_filename(assigns.filename) |> raw() %>
        </div>
        <div class="flex items-center">
          <span id={"#{@id}-message"} class="text-sm mr-2"></span>
          <.link
            id={"#{@id}-link"}
            phx-hook="CopyToClipboard"
            data-target-container={"#{@id}-target"}
            data-message-container={"#{@id}-message"}
            class="flex rounded-full p-2 hover:bg-gray-200"
            aria-label="Copy to clipboard"
          >
            <.icon name="hero-clipboard-document" class="w-4 h-4" />
          </.link>
          <a
            target="_blank"
            href={github_url(assigns.filename)}
            class="flex rounded-full p-2 hover:bg-gray-200"
            aria-label="Open in GitHub"
          >
            <.icon name="hero-arrow-top-right-on-square" class="w-4 h-4" />
          </a>
        </div>
      </div>
      <div class="overflow-auto overscroll-auto bg-white px-4 py-5 sm:p-6">
        <div class="text-lg text-gray-500 tracking-widest -mt-2 mb-3">...</div>
        <div id={"#{@id}-target"}>
          <%= @highlighted_code %>
        </div>
        <div class="text-lg text-gray-500 tracking-widest mb-1">...</div>
      </div>
    </div>
    """
  end

  def code_block(assigns) do
    assigns =
      assigns
      |> assign_new(:id, fn -> String.replace(assigns.filename, "/", "-") end)
      |> assign_new(:highlighted_code, fn ->
        read_file(assigns.filename)
        |> hide_marked()
        |> Makeup.highlight()
        |> raw()
      end)

    ~H"""
    <div class="rounded-lg bg-[#f9f9f9] border border-gray-200 text-xs xl:text-sm" aria-label="Code block">
      <div class="flex justify-between items-center px-4 py-3 sm:px-6 text-gray-500">
        <div class="overflow-hidden text-ellipsis font-mono">
          <%= responsive_filename(assigns.filename) |> raw() %>
        </div>
        <div class="flex items-center">
          <span id={"#{@id}-message"} class="text-sm mr-2"></span>
          <.link
            id={"#{@id}-link"}
            phx-hook="CopyToClipboard"
            data-target-container={"#{@id}-target"}
            data-message-container={"#{@id}-message"}
            class="flex rounded-full p-2 hover:bg-gray-200"
            aria-label="Copy to clipboard"
          >
            <.icon name="hero-clipboard-document" class="w-4 h-4" />
          </.link>
          <a
            target="_blank"
            href={github_url(assigns.filename)}
            class="flex rounded-full p-2 hover:bg-gray-200"
            aria-label="Open in GitHub"
          >
            <.icon name="hero-arrow-top-right-on-square" class="w-4 h-4" />
          </a>
        </div>
      </div>
      <div id={"#{@id}-target"} class="overflow-auto overscroll-auto bg-white px-4 py-5 sm:p-6 rounded-b-lg">
        <%= @highlighted_code %>
      </div>
    </div>
    """
  end

  # Generates a responsive display name for files, optimizing for different screen sizes.
  defp responsive_filename(filename) do
    """
    <span class="hidden md:inline">#{Path.dirname(filename)}/</span>#{Path.basename(filename)}
    """
  end

  # Constructs a GitHub URL for a given file path within the repository.
  defp github_url(filename) do
    "https://github.com/erikuus/phoenix-playground/tree/main/#{filename}"
  end

  # Removes marked sections from code intended to be hidden in the display.
  defp hide_marked(code) do
    contains = String.contains?(code, "<!-- start hiding from live code -->")
    hide_marked(code, contains)
  end

  defp hide_marked(code, true) do
    code
    |> String.split(["<!-- start hiding from live code -->", "<!-- end hiding from live code -->"])
    |> Enum.take_every(2)
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.join()
  end

  defp hide_marked(code, false), do: code

  # Extracts a section of code between specified markers.
  defp show_marked(code, from, to, elixir) do
    contains = String.contains?(code, from)
    show_marked(code, from, to, elixir, contains)
  end

  defp show_marked(code, from, to, elixir, true) do
    code
    |> String.split([from, to])
    |> tl()
    |> Enum.take_every(2)
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.join("\n")
    |> hide_comment(elixir)
    |> String.trim_leading("\n")
  end

  defp show_marked(code, _, _, _, false), do: code

  # This regex matches lines with exactly one # (ignores ## or more at the start of a line)
  defp hide_comment(code_string, true) do
    regex = ~r/^\s*#(?!\#)[^\n]*$/m
    Regex.replace(regex, code_string, "")
  end

  defp hide_comment(code_string, false), do: String.trim_leading(code_string)

  @doc """
  Generates placeholder text by creating a string of specified number of words from Lorem Ipsum.

  ## Parameters
  - `count`: The number of words to include in the placeholder text.
  - `random`: A boolean to determine whether the words should be picked randomly (`true`) or sequentially (`false`). Default is `false`.

  ## Returns
  - A string consisting of `count` Lorem Ipsum words.

  ## Examples
      <%= placeholder_words(10) %>
  """
  def placeholder_words(count, random \\ false) do
    String.split(get_lorem_ipsum(), " ", trim: true)
    |> shuffle(random)
    |> Enum.slice(0..(count - 1))
    |> Enum.join(" ")
  end

  @doc """
  Generates placeholder text by creating a string of specified number of sentences from Lorem Ipsum.

  ## Parameters
  - `count`: The number of sentences to include in the placeholder text.
  - `random`: A boolean to determine whether the sentences should be picked randomly (`true`) or sequentially (`false`). Default is `false`.

  ## Returns
  - A string consisting of `count` Lorem Ipsum sentences, formatted as a single paragraph.

  ## Examples
      <%= placeholder_sentences(3) %>
  """
  def placeholder_sentences(count, random \\ false) do
    sentences =
      String.split(get_lorem_ipsum(), ".", trim: true)
      |> shuffle(random)
      |> Enum.slice(0..(count - 1))
      |> Enum.join(". ")

    "#{String.trim(sentences)}."
  end

  @doc """
  Generates placeholder text by creating HTML paragraphs from specified number of Lorem Ipsum paragraphs.

  ## Parameters
  - `count`: The number of paragraphs to include in the placeholder text.
  - `random`: A boolean to determine whether the paragraphs should be picked randomly (`true`) or sequentially (`false`). Default is `false`.

  ## Returns
  - A list of HTML elements, each containing a Lorem Ipsum paragraph.

  ## Examples
      <%= placeholder_paragraphs(20, true) %>
  """
  def placeholder_paragraphs(count, random \\ false) do
    String.split(get_lorem_ipsum(), "\n\n", trim: true)
    |> shuffle(random)
    |> Enum.slice(0..(count - 1))
    |> Enum.map(&Phoenix.HTML.Tag.content_tag(:p, &1))
  end

  # Reads the Lorem Ipsum text from a static file.
  defp get_lorem_ipsum() do
    read_file("priv/static/text/lorem_ipsum")
  end

  # Shuffles the elements of a list if `shuffle` is `true`, returns the list unchanged otherwise.
  defp shuffle(list, true), do: Enum.shuffle(list)
  defp shuffle(list, false), do: list
end
