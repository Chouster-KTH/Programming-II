defmodule Prime do
  def main() do
    ls = [
      256,
      512,
      1024,
      2 * 1024,
      4 * 1024,
      8 * 1024,
      16 * 1024,
      32 * 1024,
      64 * 1024,
      128 * 1024
    ]

    Enum.map(ls, fn n -> run(n) end)
  end

  def run(n) do
    t1 = elem(:timer.tc(fn -> firstSolution(n) end), 0)
    t2 = elem(:timer.tc(fn -> secondSolution(n) end), 0)
    t3 = elem(:timer.tc(fn -> thirdSolution(n) end), 0)
    IO.write("n=#{n}\t\t\tt1=#{t1}\t\t\tt2=#{t2}\t\t\tt3=#{t3}\n")
  end

  def firstSolution(n) do
    list = Enum.to_list(2..n)
    list = filter(list, 0)
  end

  def filter(list, i) do
    count = Enum.count(list)
    if i >= count do
      list
    else
      n = Enum.at(list, i)
      list =
        Enum.filter(
          list,
          fn num -> rem(num, n) != 0 || num <= n end
        )
      list = filter(list, i + 1)
    end
  end

  def secondSolution(n) do
    list = Enum.to_list(2..n)
    primeNumbers = []
    primeNumbers = secondSolution(list, primeNumbers)
  end

  def secondSolution(list, primeNumbers) do
    if list != [] do
      [head | tail] = list
      primeNumbers = addPrimeAtTheEnd(head, primeNumbers)
      primeNumbers = secondSolution(tail, primeNumbers)
    else
      primeNumbers
    end
  end

  def addPrimeAtTheEnd(num, primeNumbers) when primeNumbers == [] do
    [num]
  end

  def addPrimeAtTheEnd(num, primeNumbers) do
    isPrime = checkIfPrime(num, primeNumbers)

    if isPrime do
      primeNumbers = primeNumbers ++ [num]
    else
      primeNumbers
    end
  end

  def thirdSolution(n) do
    list = Enum.to_list(2..n)
    primeNumbers = []
    primeNumbers = thirdSolution(list, primeNumbers)
    primeNumbers = Enum.reverse(primeNumbers)
  end

  def thirdSolution(list, primeNumbers) do
    if list != [] do
      [head | tail] = list
      primeNumbers = addPrimeAsHead(head, primeNumbers)
      primeNumbers = thirdSolution(tail, primeNumbers)
    else
      primeNumbers
    end
  end

  def addPrimeAsHead(num, primeNumbers) when primeNumbers == [] do
    [num]
  end

  def addPrimeAsHead(num, primeNumbers) do
    isPrime = checkIfPrime(num, primeNumbers)

    if isPrime do
      primeNumbers = [num | primeNumbers]
    else
      primeNumbers
    end
  end

  def checkIfPrime(num, primeNumbers) do
    if primeNumbers == [] do
      true
    else
      [head | tail] = primeNumbers

      if rem(num, head) == 0 do
        false
      else
        checkIfPrime(num, tail)
      end
    end
  end
end
