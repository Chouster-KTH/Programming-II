defmodule huffman do

  def sample do
  'the quick brown fox jumps over the lazy dog this is a sample text that we will use when we build up a table we will only handle lower case letters and no punctuation symbols the frequency will of course not represent english but it is probably not that far off'
  end

  def text() do
  'this is something that we should encode'
  end

  def test do
  sample = sample()
  tree = tree(sample)
  encode = encode_table(tree)
  decode = decode_table(tree)
  #text = text()
  seq = encode(sample, encode)
  decode(seq, decode)
  end

  def test_encode(sample) do
    tree = tree(sample)
    encode = encode_table(tree)
    seq = encode(sample, encode)
  end

  def test_decode(sample, tree, encode, decode) do
    seq = encode(sample, encode)
    decode(seq, decode)
  end

  def main() do
    sample = read("kallocain.txt")
    ls = [1_000, 10_000, 100_000, 300_000]
    Enum.map(ls, fn n -> run(sample, n) end)
  end

  def run(sample, n) do
    {current_text, rest} = Enum.split(sample, n)
    calculate_time(current_text, n)
  end

  def calculate_time(text, n) do
    tree = tree(text)
    encode = encode_table(tree)
    decode = decode_table(tree)
    t1 = elem(:timer.tc(fn -> test_encode(text) end), 0)
    t2 = elem(:timer.tc(fn -> test_decode(text, tree, encode, decode) end), 0)
    IO.write("elements = #{n}\tencode=#{t1}\tdecode=#{t2}\n")
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
    {:incomplete, list, _} -> list
    list -> list
  end
end

  def tree(sample) do
  freq = freq(sample)
  huffman(freq)
  end

  def encode_table() do
  encode_table(tree([]))
  end

def encode_table() do encode_table(tree([])) end
def encode_table(tree) do get_binary_numbers(tree, []) end
 def get_binary_numbers({a, b}, sequence) do
 get_binary_numbers(a, [0 | sequence]) ++ get_binary_numbers(b, [1 | sequence]) end
def get_binary_numbers(a, sequence) do
  [{a, Enum.reverse(sequence)}]
end

def encode([], table) do [] end
def encode([char | rest], table) do find(char, table) ++ encode(rest, table) end

def find(char, [{char_in_table, sequence} | rest]) do
  if char != char_in_table do
  find(char, rest)
  else
    sequence
  end
end

  def decode_table(tree), do: get_binary_numbers(tree, [])

  def decode([], _) do [] end
  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} -> {char, rest}
      nil -> decode_char(seq, n + 1, table)
    end
  end

def huffman(freq) do
  sortedFreq = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y end)
  huffman_tree(sortedFreq)
end


def huffman_tree([{tree, _}]) do tree end
def huffman_tree([{a, a_freq}, {b, b_freq} | rest]) do huffman_tree(insert({{a, b}, a_freq + b_freq}, rest)) end

def insert({a, a_freq}, []) do [{a, a_freq}] end
def insert({a, a_freq}, [{b, b_freq} | rest]) when a_freq < b_freq do
  [{a, a_freq}, {b, b_freq} | rest]
end
def insert({a, a_freq}, [{b, b_freq} | rest]) do
  [{b, b_freq} | insert({a, a_freq}, rest)]
end

  def freq(sample) do freq(sample, []) end
  def freq([], freq) do freq end
  def freq([char | rest], freq) do freq(rest, changeFreq(char, freq)) end

  def changeFreq(char, []) do [{char, 1}] end
  def changeFreq(char, [{x, freq} = head | tail]) do
    if char == x do
      [{x, freq + 1} | tail]
    else
      [head] ++ changeFreq(char, tail)
  end
end

end
