defmodule Derivative do
  @type literal() :: {:num, number()} | {:var, atom()}
  @type expr() ::
          {:exp, literal(), {:num, number()}}
          | {:add, expr(), expr()}
          | {:mul, expr(), expr()}
          | {:div, expr(), expr()}
          | {:ln, expr()}
          | {:sin, expr()}
          | literal()

  @spec deriv(expr(), atom()) :: expr()

  def test() do
    test =
    # {:add, {:mul, {:num, 4}, {:div, {:var, :x}, {:num, 3}}},
    # {:add, {:mul, {:num, 3}, {:var, :x}}, {:num, 12}}}
    # {:div, {:num, 6}, {:num, 0}}
    # {:div, {:var, :x}, {:num, 3}}
    # {:mul, {:var, :x}, {:div, {:num, 6}, {:num, 3}}}
    # {:exp, {:var, :x}, {:num, 1/2}}
    # {:exp, {:num, 4}, {:num, 1/2}}
    # {:mul, {:num, 5}, {:ln, {:var, :x}}} # 5 * ln x
    # {:mul, {:num, 5}, {:ln, {:mul, {:num, 3},{:var, :x}}}} # 5*ln(3x)
    # {:sin, {:var, :x}}
    # {:mul, {:mul, {:num, 5}, {:sin, {:var, :x}}}, {:num, 3}} # (5*sin x)*3
    # {:mul, {:div, {:num, 6}, {:num, 3}}, {:div, {:var, :x}, {:num, 2}}} # 6/3 * x/2
    # {:div, {:num, 5}, {:var, :x}}
      {:add, {:mul, {:exp, {:var, :x}, {:num, 2}}, {:num, 2}}, {:ln, {:var, :x}}} # ( x^2 * 2 ) + ln x
    # {:div, {:num, 3}, {:num, 0}}
    # {:exp, {:num, 4}, {:num, 0}}

    der = deriv(test, :x)

    case der do
      "ERROR: Cannot divide by zero!" ->
        IO.write("#{der}!\n")

      _ ->
        simpleForm = simplify(der)
        IO.write("expression: #{pprint(test)}\n")
        IO.write("derivative: #{pprint(der)}\n")
        IO.write("simplified: #{pprint(simpleForm)}\n")
    end
  end

  def deriv({:num, _}, _) do
    {:num, 0}
  end

  def deriv({:var, v}, v) do
    {:num, 1}
  end

  def deriv({:var, _}, _) do
    {:num, 0}
  end

  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end

  def deriv({:mul, e1, e2}, v) do
    {:add, {:mul, deriv(e1, v), e2}, {:mul, e1, deriv(e2, v)}}
  end

  def deriv({:exp, _, {:num, 0}}, v) do
    {:num, 1}
  end

  def deriv({:exp, x, {:num, n}}, v) do
    {:mul, {:mul, {:num, n}, {:exp, x, {:num, n - 1}}}, deriv(x, v)}
  end

  def deriv({:div, _, {:num, 0}}, v) do
    "ERROR: Cannot divide by zero!"
  end

  def deriv({:div, {:num, numerator}, {:num, denominator}}, _) do
    {:num, 0}
  end

  def deriv({:div, {:num, 0}, _}, v) do
    {:num, 0}
  end

  def deriv({:div, {:var, :x}, {:num, denominator}}, x) do
    {:div, {:num, 1}, {:num, denominator}}
  end

  def deriv({:div, {:num, numerator}, {:var, :x}}, x) do
    {:mul, {:mul, {:num, -1}, {:num, numerator}}, {:exp, {:var, x}, {:num, -2}}}
  end

  def deriv({:div, {:var, numerator}, {:var, denominator}}, x) do
    {:div,
     {{:add, {:mul, deriv(numerator, x), denominator}, {:mul, -deriv(denominator, x), numerator}}},
     :exp, denominator, {:num, 2}}
  end

  def deriv({:ln, {:var, :x}}, x) do
    {:div, {:num, 1}, {:var, :x}}
  end

  def deriv({:ln, {:mul, {:num, number}, {:var, :x}}}, x) do
    {:div, {:num, 1}, {:var, :x}}
  end

  def deriv({:sin, {:var, :x}}, x) do
    {:cos, {:var, :x}}
  end

  def simplify({:num, n}) do
    {:num, n}
  end

  def simplify({:var, v}) do
    {:var, v}
  end

  def simplify({:div, numerator, denominator}) do
    simplify_div(simplify(numerator), simplify(denominator))
  end

  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:mul, {:num, 0}, _}) do
    {:num, 0}
  end

  def simplify({:mul, _, {:num, 0}}) do
    {:num, 0}
  end

  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify({:cos, {:var, x}}) do
    {:cos, {:var, x}}
  end

  def simplify_div({:num, 0}, e) do
    {:num, 0}
  end

  def simplify_div({:var, x}, denominator) do
    {:div, {:num, 1}, {denominator}}
  end

  def simplify_div({:num, numerator}, {:var, x}) do
    {:div, {:num, numerator}, {:var, x}}
  end

  def simplify_div({:num, n}) do
    {:num, n}
  end

  def simplify_div({:num, numerator}, {:num, denominator}) do
    {:div, {:num, numerator}, {:num, denominator}}
  end

  def simplify_div(e1, e2) do
    {:num, e1 / e2}
  end

  def simplify_add({:num, 0}, e) do
    e
  end

  def simplify_add({:num, n1}, {:num, n2}) do
    {:num, n1 + n2}
  end

  def simplify_add({:var, v}, {:var, v}) do
    {:mul, {:num, 2}, {:var, v}}
  end

  def simplify_add(e1, e2) do
    {:add, e1, e2}
  end

  def simplify_mul({:num, n1}, {:num, n2}) do
    {:num, n1 * n2}
  end

  def simplify_mul({:num, 0}, _) do
    {:num, 0}
  end

  def simplify_mul(_, {:num, 0}) do
    {:num, 0}
  end

  def simplify_mul({:num, 1}, n) do
    n
  end

  def simplify_mul(n, {:num, 1}) do
    n
  end

  def simplify_mul({:var, v}, {:var, v}) do
    {:exp, {:var, v}, {:num, 2}}
  end

  def simplify_mul({:exp, {:var, v}, {:num, n}}, {:var, v}) do
    {:exp, {:var, v}, {:num, n + 1}}
  end

  def simplify_mul({:var, v}, {:exp, {:var, v}, {:num, n}}) do
    {:exp, {:var, v}, {:num, n + 1}}
  end

  def simplify_mul({:num, n1}, {:mul, {:num, n2}, e}) do
    {:mul, {:num, n1 * n2}, e}
  end

  def simplify_mul({:num, n1}, {:mul, e, {:num, n2}}) do
    {:mul, {:num, n1 * n2}, e}
  end

  def simplify_mul({:mul, {:num, n1}, e}, {:num, n2}) do
    {:mul, {:num, n1 * n2}, e}
  end

  def simplify_mul({:mul, e, {:num, n1}}, {:num, n2}) do
    {:mul, {:num, n1 * n2}, e}
  end

  def simplify_mul(e1, e2) do
    {:mul, e1, e2}
  end

  def simplify_exp(e, {:num, 1}) do
    e
  end

  def simplify_exp(e1, e2) do
    {:exp, e1, e2}
  end

  def pprint({:div, numerator, denominator}) do
    "( #{pprint(numerator)} / #{pprint(denominator)} )"
  end

  def pprint({:div, {:num, numerator}, {:num, denominator}}) do
    "( #{pprint(numerator)} / #{pprint(denominator)} )"
  end

  def pprint({:num, n}) do
    "#{n}"
  end

  def pprint({:var, v}) do
    "#{v}"
  end

  def pprint({:ln, {:var, x}}) do
    "ln x"
  end

  def pprint({:cos, {:var, x}}) do
    "cos x"
  end

  def pprint({:sin, {:var, x}}) do
    "sin x"
  end

  def pprint({:add, e1, {:num, 0}}) do
    "#{pprint(e1)}"
  end

  def pprint({:add, {:num, 0}, e2}) do
    "#{pprint(e2)}"
  end

  def pprint({:mul, n1, {:div, {:num, n}, n2}}) do
    "( #{pprint(n1)} / #{pprint(n2)} )"
  end

  def pprint({:mul, {:div, {:num, n}, n2}, n1}) do
    "( #{pprint(n1)} / #{pprint(n2)} )"
  end

  def pprint({:ln, e}) do
    "( ln #{pprint(e)} )"
  end

  def pprint({:add, e1, e2}) do
    "#{pprint(e1)} + #{pprint(e2)}"
  end

  def pprint({:mul, e1, e2}) do
    "( #{pprint(e1)} * #{pprint(e2)} )"
  end

  def pprint({:exp, e1, e2}) do
    "#{pprint(e1)}^#{pprint(e2)}"
  end
end
