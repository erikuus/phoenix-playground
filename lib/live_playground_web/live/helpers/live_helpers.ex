defmodule LivePlaygroundWeb.Helpers.LiveHelpers do
  import Phoenix.LiveView.Helpers
  import LivePlaygroundWeb.Helpers.FileHelper

  def live_modal(component, opts, close_opts \\ %{capture_close: true, show_close_btn: false}) do
    live_component(
      LivePlaygroundWeb.Components.ModalComponent,
      id: :modal,
      component: component,
      opts: opts,
      return_to: Keyword.fetch!(opts, :return_to),
      close_opts: close_opts
    )
  end

  def live_code(filename, starting \\ nil, ending \\ nil) do
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
