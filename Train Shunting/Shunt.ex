defmodule Shunt do

  def split(xs, y) do {Lists.take(xs, Lists.position(xs, y) - 1), Lists.drop(xs, Lists.position(xs, y))} end

  def find(xs, xy) do find(xs, xy, []) end
  def find([], [], listOfMoves) do listOfMoves end
  def find(xs, xy, listOfMoves) do getMoves(xs, xy, listOfMoves, :find) end

  def few(xs, xy) do few(xs, xy, []) end
  def few([], [], listOfMoves) do listOfMoves end
  def few([first_xs|tail] = xs, [y | ty] = xy, listOfMoves) do
    if y != first_xs do
      getMoves(xs, xy, listOfMoves, :few)
    else
      few(tail, ty, listOfMoves)
  end
end

def getMoves(xs, [y | ty] = xy, listOfMoves, instruction) do
    {hs, ts} = split(xs, y) # 1. Split xs into hs and ts
    step2 = Moves.single(instruction = {:one, 1 + Enum.count(ts)}, {xs,[],[]}) # 2. Move y and ts to track one
    listOfMoves = Lists.append(listOfMoves, [instruction])
    step3 = Moves.single(instruction = {:two, Enum.count(hs)}, step2) # 3. Move hs to track two
    listOfMoves = Lists.append(listOfMoves, [instruction])
    step4 = Moves.single(instruction = {:one, -(1 + Enum.count(ts))}, step3) # 4. Move from one to main
    listOfMoves = Lists.append(listOfMoves, [instruction])
    step5 = Moves.single(instruction = {:two, -(Enum.count(hs))}, step4) # 5. Move from two to main
    listOfMoves = Lists.append(listOfMoves, [instruction])
    [_ | next_xs] = elem(step5, 0)
    [_ | next_xy] = xy
     case instruction do
       :find -> find(next_xs, next_xy, listOfMoves)
       :few -> few(next_xs, next_xy, listOfMoves)
      end
end

def compress(ms) do
  ns = rules(ms)
  if ns == ms do
    ms
  else
    compress(ns)
  end
end

def rules([]) do [] end
def rules([{trackNumber1, 0} | tail] = ms) do
  if tail != [] do
  rules(tail)
  else
    []
  end
end

def rules([{trackNumber1, n1} = head | tail] = ms) do
  if tail != [] do
    [{trackNumber2, n2} | tail_2] = tail
    if trackNumber1 == trackNumber2 do
      rules(Lists.append([{trackNumber1, n1 + n2}], tail_2))
   else
    if tail_2 != [] do
      Lists.append([{trackNumber1, n1}], rules(tail))
    else
      ms
    end
  end
else
  [head]
   end
end

    # Test functions
    def runCompress() do compress([{:two,-1},{:one,1},{:one,-1},{:two,1}]) end
    #def runCompress() do compress([{:one,0},{:two,2},{:two,1},{:one,1},{:two,0},{:two,-1},{:two,1},{:one,-1},{:two,0}]) end
    def runRules() do rules([{:one,-1},{:one,1},{:two,0},{:two,-1},{:two,-1},{:two,-1},{:one,3}]) end
    #def runFind() do find([:c,:a,:b], [:c,:b,:a]) end
    def runFind() do find([:a,:b], [:b,:a]) end
    #def runFew() do few([:c,:a,:b], [:c,:b,:a]) end
    def runFew() do few([:c,:a,:b,:d], [:d,:c,:b,:a]) end

end
