defmodule Moves do

  def single({_, 0}, currentState) do currentState end # no wagons are moved, do nothing
  def single({trackNumber, n}, currentState = {main, one, two}) when n > 0 do
    wagonsToBeMoved = Lists.drop(main, Enum.count(main) - n) # get the n rightmost elements of the main track
    case trackNumber do
      :one -> # move elements
      currentState = {main = Lists.take(main, Enum.count(main) - n), one = Lists.append(wagonsToBeMoved, one), two}
      :two ->
      currentState = {main = Lists.take(main, Enum.count(main) - n), one, two = Lists.append(wagonsToBeMoved, two)}
    end
  end

  def single({trackNumber, n}, currentState = {main, one, two}) when n < 0 do
    case trackNumber do
      :one ->
      wagonsToBeMoved = Lists.take(one, -n) # get the n leftmost elements of the first track
      currentState = {main = Lists.append(wagonsToBeMoved, main), one = Lists.drop(one, -n), two} # move elements
      :two ->
      wagonsToBeMoved = Lists.take(two, -n) # get the n leftmost elements of the second track
      currentState = {main = Lists.append(wagonsToBeMoved, main), one, two = Lists.drop(two, -n)} # move elements
      end
    end

    def move(listOfMoves, currentState) do move(listOfMoves, currentState, stateHistory = [currentState]) end
    def move([nextInstruction | tail] = listOfMoves, currentState, stateHistory) do
      currentState = single(nextInstruction, currentState)
      if tail != [] do
        move(tail, currentState, stateHistory = Lists.append(stateHistory, [currentState]))
      else
        Lists.append(stateHistory, [currentState])
      end
    end
    
    # Test run
    def runMove() do move([{:one,1},{:two,1},{:one,-1}], {[:a,:b],[],[]}) end

  end
