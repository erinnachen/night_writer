require 'minitest'
require_relative '../night_write'

class NightWriteTest < Minitest::Test
  def test_encode_to_braille_single_letter
    nw = NightWriter.new
    out = nw.encode_to_braille("a")
    assert_equal "0.\n..\n..\n", out
  end

  def test_parser
    nw = NightWriter.new(2)
    out = nw.encode_to_braille("ab")
    assert_equal "0.\n..\n..\n0.\n0.\n..\n", out
    out = nw.encode_to_braille("AB")
    assert_equal "..\n..\n.0\n0.\n..\n..\n..\n..\n.0\n0.\n0.\n..\n", out
  end


  def test_encode_to_braille_two_lowercase_letters
    nw = NightWriter.new
    out = nw.encode_to_braille("ab")
    assert_equal "0.0.\n..0.\n....\n", out
  end

  def test_encode_to_braille_one_uppercase_letter
    nw = NightWriter.new
    out = nw.encode_to_braille("A")
    assert_equal "..0.\n....\n.0..\n", out
  end

  def test_encode_to_braille_two_uppercase_letters
    nw = NightWriter.new
    out = nw.encode_to_braille("AB")
    assert_equal "..0...0.\n......0.\n.0...0..\n", out
  end

  def test_encode_to_braille_40_lowercase_letters
    nw = NightWriter.new
    out = nw.encode_to_braille("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    assert_equal "0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.\n................................................................................\n................................................................................\n", out
  end

  def test_encode_to_braille_41_lowercase_letters
    nw = NightWriter.new
    out = nw.encode_to_braille("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    assert_equal "0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.\n................................................................................\n................................................................................\n0.\n..\n..\n", out
  end

  def test_encode_to_braille_all_characters
    nw = NightWriter.new
    out = nw.encode_to_braille(" !',-.?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    assert_equal "..............0.0.00000.00000..0.00.0.00000.00000..0.00.0..000000...0...0...00..\n..00..0...000...0....0.00.00000.00..0....0.00.00000.00..0.00...0.0......0.......\n..0.0...00.000....................0.0.0.0.0.0.0.0.0.0.0000.0000000.0...0...0...0\n00..0...00..00..0....0...0..0...0...00..00..0...00..00..0....0...0..0...0....0..\n.0...0..0...00..00..0...00......0........0...0..0...00..00..0...00......0...00..\n...0...0...0...0...0...0...00..00..00..00..00..00..00..00..00..00..000.000.0.0.0\n00..00..0.\n.....0...0\n00.000.000\n", out
  end

  def test_hello_world_write
    `rm hello_world_braille.txt`
    # Check if file does not exist
    `ruby night_write.rb hello_world.txt hello_world_braille.txt`
    # check if file exists
    assert_equal "0.0.0.0.0....00.0.0.00\n00.00.0..0..00.0000..0\n....0.0.0....00.0.0...\n",
    File.read("hello_world_braille.txt")
  end

end
