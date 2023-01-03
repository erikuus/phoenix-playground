defmodule LivePlaygroundWeb.FileHelpers do
  def read_file(filename) do
    Path.expand("./")
    |> Path.join(filename)
    |> File.read()
    |> handle_read_result()
  end

  defp handle_read_result({:ok, file_contents}) do
    file_contents
  end

  defp handle_read_result({:error, :enoent}) do
    "File not found!"
  end

  defp handle_read_result({:error, reason}) do
    "Reading file failed: #{reason}!"
  end
end
