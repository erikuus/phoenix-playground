defmodule LivePlaygroundWeb.DemoHelpers do
  @moduledoc """
  Provides specialized components and utility functions for enhancing the functionality within the playground.
  """
  import Phoenix.HTML
  import LivePlaygroundWeb.FileHelpers
  import LivePlaygroundWeb.CoreComponents

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
      <iframe class={[@height, "w-full h-96 overflow-hidden rounded-lg ring-1 ring-slate-900/10"]} src={@src}></iframe>
      <div
        id={"#{@id}-handler"}
        data-ruler={"#{@id}-ruler"}
        data-container={"#{@id}-container"}
        data-overlay={"#{@id}-overlay"}
        phx-hook={@hook}
        class="absolute inset-y-0 left-full hidden cursor-ew-resize items-center px-2 sm:flex"
      >
        <div class="h-8 w-1.5 rounded-full bg-slate-400"></div>
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
    <a target="_blank" class="underline" href={@url}><%= render_slot(@inner_block) %></a>
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
    <a class="flex items-center" target="_blank" href={"#{github_url(assigns.filename)}#:~:text=#{@definition}"}>
      <span><%= render_slot(@inner_block) %></span>
      <.icon name="hero-arrow-top-right-on-square" class="ml-1 w-4 h-4" />
    </a>
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
    <div class="rounded-lg bg-white border border-gray-200 text-sm xl:text-base">
      <div class="overflow-hidden text-ellipsis px-4 py-3 sm:px-6 text-gray-400 font-mono">
        <div class="flex justify-between items-center">
          <div>
            <%= responsive_filename(assigns.filename) |> raw() %>
          </div>
          <div class="flex">
            <.link
              id={"#{@id}-link"}
              phx-hook="CopyToClipboard"
              data-target-div={@id}
              class="flex rounded-full p-2 text-gray-400 hover:bg-gray-200"
            >
              <.icon name="hero-clipboard-document" class="w-4 h-4" />
            </.link>
            <a target="_blank" href={github_url(assigns.filename)} class="flex rounded-full p-2 text-gray-400 hover:bg-gray-200">
              <.icon name="hero-arrow-top-right-on-square" class="w-4 h-4" />
            </a>
          </div>
        </div>
      </div>
      <div class="overflow-auto overscroll-auto bg-[#f8f8f8] px-4 py-5 sm:p-6">
        <div class="text-lg text-gray-400 tracking-widest -mt-2 mb-3">...</div>
        <div id={@id}>
          <%= @highlighted_code %>
        </div>
        <div class="text-lg text-gray-400 tracking-widest mb-1">...</div>
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
    <div class="rounded-lg bg-white border border-gray-200 text-sm xl:text-base">
      <div class="overflow-hidden text-ellipsis px-4 py-3 sm:px-6 text-gray-400 font-mono">
        <div class="flex justify-between items-center">
          <div>
            <%= responsive_filename(assigns.filename) |> raw() %>
          </div>
          <div class="flex">
            <.link
              id={"#{@id}-link"}
              phx-hook="CopyToClipboard"
              data-target-div={@id}
              class="flex rounded-full p-2 text-gray-400 hover:bg-gray-200"
            >
              <.icon name="hero-clipboard-document" class="w-4 h-4" />
            </.link>
            <a target="_blank" href={github_url(assigns.filename)} class="flex rounded-full p-2 text-gray-400 hover:bg-gray-200">
              <.icon name="hero-arrow-top-right-on-square" class="w-4 h-4" />
            </a>
          </div>
        </div>
      </div>
      <div id={@id} class="overflow-auto overscroll-auto bg-[#f8f8f8] px-4 py-5 sm:p-6">
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
    |> String.trim_leading("\n")
    |> hide_comment(elixir)
  end

  defp show_marked(code, _, _, _, false), do: code

  # Processes and removes comments from Elixir code.
  defp hide_comment(code_string, true) do
    code_string
    |> Code.string_to_quoted!()
    |> Macro.to_string()
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
