defmodule LivePlaygroundWeb.DemoHelpers do
  @moduledoc """
  Offers specialized components and functions tailored to enhance the functionality of this playground.
  """
  import Phoenix.HTML
  import LivePlaygroundWeb.FileHelpers

  use Phoenix.Component

  @doc """
  Display resizable iframe
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
  Renders a link to Github.

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
  Renders a link to Github that jumps to given function definition.

  ## Example

      <.goto_definition
        filename="lib/live_playground_web/components/more_components.ex"
        definition="def multi_column_layout">
        Goto Definition
      </.goto_definition>
  """
  attr :filename, :string, required: true
  attr :definition, :string, required: true

  slot :inner_block, required: true

  def goto_definition(assigns) do
    assigns =
      assigns
      |> assign_new(:dirname, fn -> Path.dirname(assigns.filename) end)
      |> assign_new(:basename, fn -> Path.basename(assigns.filename) end)

    ~H"""
    <a
      class="flex items-center"
      target="_blank"
      href={"https://github.com/erikuus/phoenix-playground/tree/main/#{@dirname}/#{@basename}#:~:text=#{@definition}"}
    >
      <span><%= render_slot(@inner_block) %></span>
      <svg
        xmlns="http://www.w3.org/2000/svg"
        fill="none"
        viewBox="0 0 24 24"
        stroke-width="1.5"
        stroke="currentColor"
        class="ml-1 w-4 h-4"
      >
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"
        />
      </svg>
    </a>
    """
  end

  @doc """
  Renders a code block with filename as title, github link as action, and highlighted code as content.

  ## Examples

      <.code_block filename="lib/live_playground_web/live/comps_live/modal.ex" />
      <.code_block filename="lib/live_playground/countries.ex" from="# search" to="# endsearch" />
  """
  attr :filename, :string, required: true
  attr :from, :string
  attr :to, :string
  attr :elixir, :boolean

  def code_block(%{filename: filename, from: from, to: to} = assigns) do
    assigns =
      assigns
      |> assign_new(:formatted_filename, fn -> format_filename(filename) |> raw() end)
      |> assign_new(:highlighted_code, fn ->
        read_file(filename)
        |> show_marked(from, to, Map.get(assigns, :elixir, true))
        |> hide_marked()
        |> Makeup.highlight()
        |> raw()
      end)

    ~H"""
    <div class="rounded-lg bg-white border border-gray-200 text-sm xl:text-base">
      <div class="overflow-hidden text-ellipsis px-4 py-5 sm:px-6 text-gray-400 font-mono">
        <%= @formatted_filename %>
      </div>
      <div class="overflow-auto overscroll-auto bg-[#f8f8f8] px-4 py-5 sm:p-6">
        <div class="text-lg text-gray-400 tracking-widest -mt-2 mb-3">...</div>
        <%= @highlighted_code %>
        <div class="text-lg text-gray-400 tracking-widest mb-1">...</div>
      </div>
    </div>
    """
  end

  def code_block(assigns) do
    assigns =
      assigns
      |> assign_new(:formatted_filename, fn -> format_filename(assigns.filename) |> raw() end)
      |> assign_new(:highlighted_code, fn ->
        read_file(assigns.filename)
        |> hide_marked()
        |> Makeup.highlight()
        |> raw()
      end)

    ~H"""
    <div class="rounded-lg bg-white border border-gray-200 text-sm xl:text-base">
      <div class="overflow-hidden text-ellipsis px-4 py-5 sm:px-6 text-gray-400 font-mono">
        <%= @formatted_filename %>
      </div>
      <div class="overflow-auto overscroll-auto bg-[#f8f8f8] px-4 py-5 sm:p-6">
        <%= @highlighted_code %>
      </div>
    </div>
    """
  end

  defp format_filename(filename) do
    dirname = Path.dirname(filename)
    basename = Path.basename(filename)

    """
    <div class="flex justify-between items-center">
      <div>
        <span class="hidden md:inline">#{dirname}/</span>#{basename}
      </div>
      <a target="_blank" href="https://github.com/erikuus/phoenix-playground/tree/main/#{dirname}/#{basename}">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
          <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
        </svg>
      </a>
    </div>
    """
  end

  defp show_marked(code, from, to, elixir) do
    contains = String.contains?(code, from)
    show(code, from, to, elixir, contains)
  end

  defp show(code, from, to, elixir, true) do
    code
    |> String.split([from, to])
    |> tl()
    |> Enum.take_every(2)
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.join("\n")
    |> String.trim_leading("\n")
    |> hide_comment(elixir)
  end

  defp show(code, _, _, _, false), do: code

  defp hide_comment(code_string, true) do
    code_string
    |> Code.string_to_quoted!()
    |> Macro.to_string()
  end

  defp hide_comment(code_string, false), do: String.trim_leading(code_string)

  defp hide_marked(code) do
    contains = String.contains?(code, "<!-- start hiding from live code -->")
    hide(code, contains)
  end

  defp hide(code, true) do
    code
    |> String.split(["<!-- start hiding from live code -->", "<!-- end hiding from live code -->"])
    |> Enum.take_every(2)
    |> Enum.map(&String.trim_trailing/1)
    |> Enum.join()
  end

  defp hide(code, false), do: code

  @doc """
  Display placeholder text

  ## Examples

      <%= placeholder_words(10) %>
      <%= placeholder_sentences(3) %>
      <%= placeholder_paragraphs(20, true) %>
  """
  def placeholder_words(count, random \\ false) do
    String.split(get_lorem_ipsum(), " ", trim: true)
    |> shuffle(random)
    |> Enum.slice(0..(count - 1))
    |> Enum.join(" ")
  end

  def placeholder_sentences(count, random \\ false) do
    sentences =
      String.split(get_lorem_ipsum(), ".", trim: true)
      |> shuffle(random)
      |> Enum.slice(0..(count - 1))
      |> Enum.join(". ")

    "#{String.trim(sentences)}."
  end

  def placeholder_paragraphs(count, random \\ false) do
    String.split(get_lorem_ipsum(), "\n\n", trim: true)
    |> shuffle(random)
    |> Enum.slice(0..(count - 1))
    |> Enum.map(&Phoenix.HTML.Tag.content_tag(:p, &1))
  end

  defp get_lorem_ipsum() do
    read_file("priv/static/text/lorem_ipsum")
  end

  defp shuffle(list, true), do: Enum.shuffle(list)

  defp shuffle(list, false), do: list
end
