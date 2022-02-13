defmodule Program do

  def test() do
     Emulator.run(convertToTuple(getMipsCode()))
  end

  def read_instruction({:code, code}, pc) do
    elem(code, pc)
  end

  def convertToTuple(list) do
    {:code, List.to_tuple(list)}
  end

  def getMipsCode() do
    [
      {:addi, 1, 0, 12}, # $1 <- 12
      {:addi, 2, 0, 33}, # $2 <- 11
      {:sw, 2, 0, 4}, # mem[0 + 4] <- $2
      {:lw, 3, 0, 4}, # $3 <- mem[0 + 4]
      {:addi, 5, 0, 1}, # $5 <- 1
      {:sub, 1, 1, 5}, # $1 <- $1 - $5
      {:out, 1}, # print $1
      {:addi, 3, 3, 27}, # $3 <- $3 + 27
      {:out, 3}, # print $3
      {:addi, 4, 0, 59}, # $4 <- 58
      {:addi, 6, 0, 1}, # $6 <- 1
      {:add, 4, 4, 6}, # $4 <- $4 + $6
      {:out, 4}, # print $4
      {:beq, 3, 4, -2}, # go back 2 instructions if $3 == $4
      {:halt} # end program
    ]
  end
end
