defmodule Moves do

  def single({_, 0}, currentState) do currentState end # return current state if no wagons are moved
  def single({trackNumber, n}, currentState = {main, one, two}) when n > 0 do
    wagonsToBeMoved = Lists.drop(main, length(main) - n) # get the n rightmost elements of the main track
    case trackNumber do 
     :one ->
      currentState = {main = Lists.take(main, length(main) - n), one = Lists.append(one, wagonsToBeMoved), two}
      :two ->
      currentState = {main = Lists.take(main, length(main) - n), one, two = Lists.append(two, wagonsToBeMoved)}
    end
  end

  def single({trackNumber, n}, currentState = {main, one, two}) when n < 0 do
    case trackNumber do
      :one ->
      wagonsToBeMoved = Lists.take(one, -n) # get the n leftmost elements of the first track
      currentState = {main = Lists.append(main, wagonsToBeMoved), one = Lists.drop(one, -n), two}
      :two ->
      wagonsToBeMoved = Lists.take(two, -n) # get the n leftmost elements of the second track
      currentState = {main = Lists.append(main, wagonsToBeMoved), one, two = Lists.drop(two, -n)}
      end
    end

    def move([], currentState) do [currentState] end 
    def move(listOfMoves, currentState) do move(listOfMoves, currentState, stateHistory = [currentState]) end
    def move([nextInstruction | tail] = listOfMoves, currentState, stateHistory)
    do currentState = single(nextInstruction, currentState) # implement next instruction
      if tail != [] do move(tail, currentState, stateHistory = Lists.append(stateHistory, [currentState])) 
      else Lists.append(stateHistory, [currentState]) end
    end

    # Test run
    def runMove() do move([{:one,1},{:two,1},{:one,-1}], {[:a,:b],[],[]}) end

  end
