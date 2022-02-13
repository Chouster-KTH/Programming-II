defmodule Out do
  def new() do
    []
  end

  def addToOutputList(list, value) do
    [value | list]
  end

  def close(out) do
    Enum.each(Enum.reverse(out), fn value -> IO.write("#{value} ") end)
  end
end
