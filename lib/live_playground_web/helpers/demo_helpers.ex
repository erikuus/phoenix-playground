defmodule LivePlaygroundWeb.DemoHelpers do
  import LivePlaygroundWeb.FileHelpers

  def lorem_ipsum_words(count, random \\ false) do
    String.split(get_lorem_ipsum(), " ", trim: true)
    |> shuffle(random)
    |> Enum.slice(0..(count - 1))
    |> Enum.join(" ")
  end

  def lorem_ipsum_sentences(count, random \\ false) do
    sentences =
      String.split(get_lorem_ipsum(), ".", trim: true)
      |> shuffle(random)
      |> Enum.slice(0..(count - 1))
      |> Enum.join(". ")

    "#{sentences}."
  end

  def lorem_ipsum_paragraphs(count, random \\ false) do
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

  def code(filename, from, to, elixir \\ true) do
    """
    <div class="rounded-lg bg-white border border-gray-200 text-sm xl:text-base">
      <div class="overflow-hidden text-ellipsis px-4 py-5 sm:px-6 text-gray-400 font-mono">
        #{format_filename(filename)}
      </div>
      <div class="overflow-auto overscroll-auto bg-[#f8f8f8] px-4 py-5 sm:p-6">
        <div class="text-lg text-gray-400 tracking-widest -mt-2 mb-3">...</div>
        #{read_file(filename) |> show_marked(from, to, elixir) |> hide_marked() |> Makeup.highlight()}
        <div class="text-lg text-gray-400 tracking-widest mb-1">...</div>
      </div>
    </div>
    """
  end

  def code(filename) do
    """
    <div class="rounded-lg bg-white border border-gray-200 text-sm xl:text-base">
      <div class="overflow-hidden text-ellipsis px-4 py-5 sm:px-6 text-gray-400 font-mono">
        #{format_filename(filename)}
      </div>
      <div class="overflow-auto overscroll-auto bg-[#f8f8f8] px-4 py-5 sm:p-6">
        #{read_file(filename) |> hide_marked() |> Makeup.highlight()}
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
end
