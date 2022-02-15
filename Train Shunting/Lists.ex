defmodule Lists do

  def take([], _) do [] end #new
  def take([head | _], 1) do [head] end
  def take(_, 0) do [] end #new
  def take([head | tail] = list, n) do [head | take(tail, n - 1)] end

  def drop([], _) do [] end #new
  def drop(list, 0) do list end #new
  def drop([_ | tail], 1) do tail end
  def drop([_ | tail], n) do drop(tail, n - 1) end

  def append(list_1, list_2) do list_1 ++ list_2 end

  def member([element | _], element) do true end
  def member([], _) do false end
  def member([_ | tail], element) do member(tail, element) end

  def position([element | _], element) do 1 end
  def position([_ | tail], element) do position(tail, element) + 1 end

end
