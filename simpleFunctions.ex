defmodule Test do

# Compute the double of a number
  def double(n) do
  n * 2
  end 

# Convert from Fahrenheit to Celsius
  def fromFahrenheitToCelcius(f) do
  (f - 32) / 1.8   
  end

# Compute the area of a rectangle
  def areaOfRec(length1, length2) do
  length1 * length2   
  end

# Compute the area of a square
  def areaOfSquare(side) do
  areaOfRec(side, side)   
  end

# Compute the area of a circle
  def areaOfCircle(r) do
  :math.pi() * r * r   
  end

# Compute m * n
  def product(m, n) do
  if m == 0 || n == 0 do
  0
  else
  n + product(m - 1, n)
  end
  end

# Compute m * n
def product_case(m, n) do
case m do
0 -> 0
_ -> n + product_case(m - 1, n)
end
end

# Compute m * n
def product_cond(m, n) do
cond do
m == 0 -> 0
n == 0 -> 0
true -> n + product_cond(m - 1, n)
end
end

# Compute m * n
def product_clauses(0, _) do 0 end
def product_clauses(m, n) do
product_clauses(m - 1, n) + n
end

# Compute x^n
def exp(x, n) do
case n do
0 -> 1
_ -> product_case(x, exp(x, n - 1))  
end
end

# Compute x^n
def exp_(x, n) do
case n do
1 -> x
_ -> 
if (rem(round(n), 2) == 0) do
exp_(x, n/2) * x
else
exp_(x, n - 1) * x 
end
end
end

# Get the nth element of a list
def nth(n, l) do
[head|tail] = l
if n == 0 do
head
else
nth(n - 1, tail)
end
end

end
