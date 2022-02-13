defmodule Bench do
  def bench() do
    bench(100)
  end

  def bench(l) do
    ls = [16, 32, 64, 128, 256, 512, 1024, 2 * 1024, 4 * 1024, 8 * 1024]

    time = fn i, f ->
      seq = Enum.map(1..i, fn _ -> :rand.uniform(100_000) end)
      elem(:timer.tc(fn -> loop(l, fn -> f.(seq) end) end), 0)
    end

    bench = fn i ->
      list = fn seq ->
        List.foldr(seq, list_new(), fn e, acc -> list_insert(e, acc) end)
      end

      tree = fn seq ->
        List.foldr(seq, tree_new(), fn e, acc -> tree_insert(e, acc) end)
      end

      tl = time.(i, list)
      tt = time.(i, tree)

      IO.write("  #{tl}\t\t\t#{tt}\n")
    end

    IO.write("# benchmark of lists and tree (loop: #{l}) \n")
    Enum.map(ls, bench)

    :ok
  end

  def loop(0, _) do
    :ok
  end

  def loop(n, f) do
    f.()
    loop(n - 1, f)
  end

  def list_new() do
    []
  end

  def list_insert(e, []) do
    [e]
  end

  def list_insert(e, l) do
    [head | tail] = l

    if e < head do
      l = [e | l]
    else
      [head | list_insert(e, tail)]
    end
  end

  # inefficient
  # def list_insert(e, l) do
  # rest = []
  # insert_and_sort(l, e, rest)
  # end

  # def insert_and_sort(l, e, rest) do
  # if Enum.count(l) == 0 do
  #  l = [e | rest]
  # l = Enum.reverse(l)
  # else
  # [head | tail] = l

  # if e < head do
  # l = [e | l]
  # rest = Enum.reverse(rest)
  # rest = rest ++ l
  # else
  # rest = [head | rest]
  # insert_and_sort(tail, e, rest)
  # end
  # end
  # end

  def tree_new() do
    nil
  end

  def tree_insert(e, nil) do
    {:leaf, e}
  end

  def tree_insert(e, {:leaf, head}) when e < head do
    {:node, e, nil, {:leaf, head}}
  end

  def tree_insert(e, {:leaf, head}) do
    {:node, e, {:leaf, head}, nil}
  end

  def tree_insert(e, {:node, head, left, right}) when e < head do
    {:node, head, tree_insert(e, left), right}
  end

  def tree_insert(e, {:node, head, left, right}) do
    {:node, head, left, tree_insert(e, right)}
  end

  def print_keys(nil) do
  end

  def print_keys({:leaf, value}) do
    IO.write(" #{value}")
  end

  def print_keys({:node, head, left, right}) do
    if head == nil do
    else
      if left == nil && right == nil do
        nil
      else
        print_keys(left)
        IO.write(" #{head}")
        print_keys(right)
      end
    end
  end
end
