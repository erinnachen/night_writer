require 'minitest'
require_relative '../night_read'

class NightReadTest < Minitest::Test

  def test_merge_multiple_lines_into_single_stream
    nr = NightReader.new
    assert_equal ['..','..','..'], nr.merge_into_three_lines("..\n..\n..")
    assert_equal ['....','....','....'], nr.merge_into_three_lines("..\n..\n..\n..\n..\n..")
  end

  def test_message_contains_a_multiple_of_3_lines
    nr = NightReader.new
    assert_equal ['..','..','..'], nr.merge_into_three_lines("..\n..\n..")
    assert_equal nil, nr.merge_into_three_lines("..\n..")
  end

  def test_message_returns_the_empty_string
    nr = NightReader.new
    assert_equal ['','',''], nr.merge_into_three_lines("")
  end

  def test_decode_from_braille_single_letter
    nr = NightReader.new
    out = nr.decode_from_braille("0.\n..\n..\n")
    assert_equal "a", out
  end

  def test_decode_from_braille_two_lowercase_letters
    nr = NightReader.new
    out = nr.decode_from_braille("0.0.\n..0.\n....\n")
    assert_equal "ab", out
  end

  def test_decode_from_braille_one_uppercase_letter
    nr = NightReader.new
    out = nr.decode_from_braille("..0.\n....\n.0..\n")
    assert_equal "A", out
  end

  def test_decode_from_braille_two_uppercase_letters
    nr = NightReader.new
    out = nr.decode_from_braille("..0...0.\n......0.\n.0...0..\n")
    assert_equal "AB", out
  end

  def test_decode_from_braille_40_lowercase_letters
    nr = NightReader.new
    out = nr.decode_from_braille( "0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.\n................................................................................\n................................................................................\n")
    assert_equal "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", out
  end

  def test_decode_to_braille_41_lowercase_letters
    nr = NightReader.new
    out = nr.decode_from_braille( "0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.\n................................................................................\n................................................................................\n0.\n..\n..\n")
    assert_equal "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", out
  end

  def test_decode_to_braille_all_characters
    nr = NightReader.new
    out = nr.decode_from_braille( "..............0.0.00000.00000..0.00.0.00000.00000..0.00.0..000000...0...0...00..\n..00..0...000...0....0.00.00000.00..0....0.00.00000.00..0.00...0.0......0.......\n..0.0...00.000....................0.0.0.0.0.0.0.0.0.0.0000.0000000.0...0...0...0\n00..0...00..00..0....0...0..0...0...00..00..0...00..00..0....0...0..0...0....0..\n.0...0..0...00..00..0...00......0........0...0..0...00..00..0...00......0...00..\n...0...0...0...0...0...0...00..00..00..00..00..00..00..00..00..00..000.000.0.0.0\n00..00..0.\n.....0...0\n00.000.000\n")
    assert_equal " !',-.?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", out
  end

  def test_hello_world_write
    `rm hello_world.txt`
    # Check if file does not exist
    `ruby night_read.rb hello_world_braille.txt hello_world.txt`
    # check if file exists
    assert_equal "hello world",
    File.read("hello_world.txt")
  end

end
