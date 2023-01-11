defmodule LivePlaygroundWeb.DevHelpers do
  import LivePlaygroundWeb.FileHelpers

  def lorem_ipsum_words(count, random \\ false) do
    String.split(lorem_ipsum_text(), " ", trim: true)
    |> shuffle(random)
    |> Enum.slice(0..(count - 1))
    |> Enum.join(" ")
  end

  def lorem_ipsum_sentences(count, random \\ false) do
    sentences =
      String.split(lorem_ipsum_text(), ".", trim: true)
      |> shuffle(random)
      |> Enum.slice(0..(count - 1))
      |> Enum.join(". ")

    "#{sentences}."
  end

  def lorem_ipsum_paragraphs(count, random \\ false) do
    String.split(lorem_ipsum_text(), "\n\n", trim: true)
    |> shuffle(random)
    |> Enum.slice(0..(count - 1))
    |> Enum.join("\n\n")
  end

  defp lorem_ipsum_text() do
    read_file("priv/static/text/lorem_ipsum")
  end

  defp shuffle(list, true), do: Enum.shuffle(list)

  defp shuffle(list, false), do: list

  def code(filename, starting \\ nil, ending \\ nil) do
    """
    <div class="overflow-auto overscroll-auto rounded-lg bg-white border border-gray-200">
      <div class="px-4 py-5 sm:px-6 text-gray-400 font-mono">
        #{filename}
      </div>
      <div class="bg-[#f8f8f8] px-4 py-5 sm:p-6 select-all">
        #{read_file(filename) |> split_code(starting, ending) |> clean_code() |> Makeup.highlight()}
      </div>
    </div>
    """
  end

  defp split_code(code, nil, nil), do: code

  defp split_code(code, starting, ending) do
    [_, code_after] = String.split(code, starting)
    [code_between | _] = String.split(code_after, ending)
    "#{starting}#{String.trim_trailing(code_between, " ")}#{ending}"
  end

  defp clean_code(code) do
    contains = String.contains?(code, "<!-- start hiding from live code -->")
    hide_code(code, contains)
  end

  defp hide_code(code, true) do
    [code_before_hiding, code_after] = String.split(code, "<!-- start hiding from live code -->")
    [_, code_after_hiding] = String.split(code_after, "<!-- end hiding from live code -->")
    "#{String.trim(code_before_hiding)} #{code_after_hiding}"
  end

  defp hide_code(code, false), do: code
end
