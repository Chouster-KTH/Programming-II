defmodule Move do

  def single({_, 0}, tracks) do tracks end # no wagons are moved, do nothing
  def single({trackNumber, n}, tracks = {main, one, two}) when n > 0 do
    wagonsToBeMoved = Lists.drop(main, Enum.count(main) - n) # get the n rightmost elements of the main track
    case trackNumber do
      :one -> # move elements
      tracks = {main = Lists.take(main, Enum.count(main) - n), one = Lists.append(wagonsToBeMoved, one), two}
      :two ->
      tracks = {main = Lists.take(main, Enum.count(main) - n), one, two = Lists.append(wagonsToBeMoved, two)}
    end
  end

  def single({trackNumber, n}, tracks = {main, one, two}) when n < 0 do
    case trackNumber do
      :one ->
      wagonsToBeMoved = Lists.take(one, -n) # get the n leftmost elements of the first track
      tracks = {main = Lists.append(wagonsToBeMoved, main), one = Lists.drop(one, -n), two} # move elements
      :two ->
      wagonsToBeMoved = Lists.take(two, -n) # get the n leftmost elements of the second track
      tracks = {main = Lists.append(wagonsToBeMoved, main), one, two = Lists.drop(two, -n)} # move elements
      end
    end

  end
