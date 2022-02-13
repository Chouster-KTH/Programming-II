defmodule Emulator do
  def run(code) do
    run(pc = 0, code, Register.new(), Memory.new(), Out.new())
  end

  def run(pc, code, reg, mem, out) do
    next = Program.read_instruction(code, pc)

    case next do
      {:addi, 0, rs, imm} ->
        IO.puts("ERROR: Cannot write to $0")

      {:add, 0, rs, rt} ->
        IO.puts("ERROR: Cannot write to $0")

      {:sub, 0, rs, rt} ->
        IO.puts("ERROR: Cannot write to $0")

      {:beq, rs, rt, imm} ->
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)

        if s == t do
          run(pc + imm, code, reg, mem, out)
        else
          run(pc + 1, code, reg, mem, out)
        end

      {:add, rd, rs, rt} ->
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        run(pc + 1, code, reg = Register.write(reg, rd, s + t), mem, out)

      {:addi, rd, rs, imm} ->
        s = Register.read(reg, rs)
        run(pc + 1, code, reg = Register.write(reg, rd, s + imm), mem, out)

      {:sub, rd, rs, rt} ->
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        run(pc + 1, code, reg = Register.write(reg, rd, s - t), mem, out)

      {:lw, rd, rs, imm} ->
        s = Register.read(reg, rs)
        value = Memory.read(mem, s + imm)
        run(pc + 1, code, reg = Register.write(reg, rd, value), mem, out)

      {:sw, rs, rt, imm} ->
        s = Register.read(reg, rs)
        t = Register.read(reg, rt)
        run(pc + 1, code, reg, mem = Memory.write(mem, t + imm, s), out)

      {:out, rs} ->
        s = Register.read(reg, rs)
        run(pc + 1, code, reg, mem, out = Out.addToOutputList(out, s))

      {:halt} ->
        Out.close(out)
    end
  end
end
