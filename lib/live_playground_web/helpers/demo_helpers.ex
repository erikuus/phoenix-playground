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

  def code(filename, from, to, tpl \\ nil) do
    """
    <div class="overflow-auto overscroll-auto rounded-lg bg-white border border-gray-200">
      <div class="px-4 py-5 sm:px-6 text-gray-400 font-mono">
        #{filename}
      </div>
      <div class="bg-[#f8f8f8] px-4 py-5 sm:p-6">
        #{read_file(filename) |> show_marked(from, to, tpl) |> hide_marked() |> Makeup.highlight()}
      </div>
    </div>
    """
  end

  def code(filename) do
    """
    <div class="overflow-auto overscroll-auto rounded-lg bg-white border border-gray-200">
      <div class="px-4 py-5 sm:px-6 text-gray-400 font-mono">
        #{filename}
      </div>
      <div class="bg-[#f8f8f8] px-4 py-5 sm:p-6">
        #{read_file(filename) |> hide_marked() |> Makeup.highlight()}
      </div>
    </div>
    """
  end

  defp show_marked(code, from, to, tpl) do
    code
    |> String.split([from, to])
    |> Enum.at(1)
    |> String.trim_trailing(" ")
    |> apply_template(tpl)
  end

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

  defp apply_template(code, :router) do
    """
      scope "/", LivePlaygroundWeb do
        pipe_through :browser

    #{String.trim(code, "\n")}
      end
    """
  end

  defp apply_template(code, _), do: String.trim(code, "\n")
end
