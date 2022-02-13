defmodule Memory do
  def new() do
    []
  end

  def read(mem, address) do
    getValue(address, mem, Enum.count(mem))
  end

  def getValue(address, mem, numOfElements) do
    [head | tail] = mem
    {addressCompared, value} = head

    if addressCompared == address do
      value
    else
      if numOfElements == 0 do
        0
      else
        getValue(address, tail, numOfElements - 1)
      end
    end
  end

  def write(mem, address, value) do
    [{address, value} | mem]
  end
end
