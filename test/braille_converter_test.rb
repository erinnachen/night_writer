require 'minitest'
require_relative '../braille_converter'

class BrailleConverterTest < Minitest::Test
  def test_load_br_message
    my_converter = BrailleConverter.new
    message = ['0...0.','......','...0..']
    my_converter.load_br_message(message)
    assert_equal 0, my_converter.ind
    assert_equal ['0...0.','......','...0..'], my_converter.br_message
  end

  def test_load_br_message_empty_string
    my_converter = BrailleConverter.new
    message = ""
    my_converter.load_br_message(message)
    assert_equal "", my_converter.br_message
    assert_equal false, my_converter.chars_left?
    assert_equal 0, my_converter.br_message_length
  end

  def test_convert_three_to_one
    my_converter = BrailleConverter.new
    assert_equal '......', my_converter.three_to_one(['..','..','..'])
    assert_equal '', my_converter.three_to_one(['','',''])
    assert_equal nil, my_converter.three_to_one(['..','..'])
    assert_equal nil, my_converter.three_to_one('hi this should return nil')
  end

  def test_single_braille_lowercase_character
    my_converter = BrailleConverter.new
    assert_equal "m", my_converter.lookup_char("00..0.")
    assert_equal "n", my_converter.lookup_char("00.00.")
    assert_equal "o", my_converter.lookup_char("0..00.")
    assert_equal "p", my_converter.lookup_char("000.0.")
    assert_equal "q", my_converter.lookup_char("00000.")
    assert_equal "r", my_converter.lookup_char("0.000.")
  end

  def test_single_braille_uppercase_character
    my_converter = BrailleConverter.new
    assert_equal "A", my_converter.lookup_char(".....00.....")
    assert_equal "B", my_converter.lookup_char(".....00.0...")
    assert_equal "C", my_converter.lookup_char(".....000....")
    assert_equal "D", my_converter.lookup_char(".....000.0..")
    assert_equal "E", my_converter.lookup_char(".....00..0..")
    assert_equal "F", my_converter.lookup_char(".....0000...")
  end

  def test_single_braille_space
    my_converter = BrailleConverter.new
    assert_equal " ", my_converter.lookup_char("......")
  end

  def test_single_braille_other_characters
    my_converter = BrailleConverter.new
    assert_equal "!", my_converter.lookup_char("..000.")
    assert_equal "'", my_converter.lookup_char("....0.")
    assert_equal ",", my_converter.lookup_char("..0...")
    assert_equal "-", my_converter.lookup_char("....00")
    assert_equal "?", my_converter.lookup_char("..0.00")
    assert_equal ".", my_converter.lookup_char("..00.0")
  end

  def test_not_valid_characters
    my_converter = BrailleConverter.new
    assert_equal nil, my_converter.lookup_char("..")
    assert_equal nil, my_converter.lookup_char("...aa")
  end

  def test_lookup_empty_string
    my_converter = BrailleConverter.new
    assert_equal "", my_converter.lookup_char("")
  end

  def test_pull_char_from_message
    my_converter = BrailleConverter.new
    message = ['0...0.','......','...0..']
    my_converter.load_br_message(message)
    assert_equal ['0.','..','..'], my_converter.pull_char_from_message
    assert_equal ['..','..','.0'], my_converter.pull_char_from_message
    assert_equal ['0.','..','..'], my_converter.pull_char_from_message
    assert_equal nil, my_converter.pull_char_from_message
  end

  def test_get_next_char
    my_converter = BrailleConverter.new
    message = ['0...0.','......','...0..']
    my_converter.load_br_message(message)
    assert_equal "0.....", my_converter.get_next_char
    assert_equal ".....00.....", my_converter.get_next_char
    assert_equal nil, my_converter.get_next_char
    assert_equal false, my_converter.chars_left?
  end

  def test_convert_empty_string
    my_converter = BrailleConverter.new
    message = ''
    assert_equal '', my_converter.convert_lines(message)
    assert_equal false, my_converter.chars_left?
  end

  def test_converts_single_lowercase_character
    my_converter = BrailleConverter.new
    message = ['0.','..','..']
    assert_equal 'a', my_converter.convert_lines(message)
    assert_equal false, my_converter.chars_left?
  end

  def test_converts_two_lowercase_characters
    my_converter = BrailleConverter.new
    message = ['0.0.','...0','..00']
    assert_equal 'az', my_converter.convert_lines(message)
    assert_equal false, my_converter.chars_left?
  end

  def test_converts_an_uppercase_characters
    my_converter = BrailleConverter.new
    message = ['..0...00','...0...0','.000.00.']
    assert_equal 'ZN', my_converter.convert_lines(message)
    assert_equal false, my_converter.chars_left?
  end

  def test_converts_all_characters
    my_converter = BrailleConverter.new
    message = ["..............0.0.00000.00000..0.00.0.00000.00000..0.00.0..000000...0...0...00..00..0...00..00..0....0...0..0...0...00..00..0...00..00..0....0...0..0...0....0..00..00..0.","..00..0...000...0....0.00.00000.00..0....0.00.00000.00..0.00...0.0......0........0...0..0...00..00..0...00......0........0...0..0...00..00..0...00......0...00.......0...0","..0.0...00.000....................0.0.0.0.0.0.0.0.0.0.0000.0000000.0...0...0...0...0...0...0...0...0...0...00..00..00..00..00..00..00..00..00..00..000.000.0.0.000.000.000"]
    assert_equal " !',-.?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", my_converter.convert_lines(message)
    assert_equal false, my_converter.chars_left?
  end

end
