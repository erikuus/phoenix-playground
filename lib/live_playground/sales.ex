defmodule LivePlayground.Sales do
  def orders do
    Enum.random(5..20)
  end

  def amount do
    Enum.random(100..1000)
  end

  def satisfaction do
    Enum.random(95..100)
  end
end
