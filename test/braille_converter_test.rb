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

  def test_braille_with_the_same_instring
    my_converter = BrailleConverter.new
    assert_equal "a", my_converter.lookup_char("0.....")
    my_converter.switch_cap_mode
    assert_equal "A", my_converter.lookup_char("0.....")
    assert_equal "a", my_converter.lookup_char("0.....")
    my_converter.switch_num_mode
    assert_equal "1", my_converter.lookup_char("0.....")
    assert_equal "2", my_converter.lookup_char("0.0...")
    assert_equal "3", my_converter.lookup_char("00....")
    my_converter.switch_num_mode
    assert_equal "d", my_converter.lookup_char("00.0..")
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
    assert_equal ['0...0.','......','...0..'], my_converter.br_message
    assert_equal "0.....", my_converter.get_next_char
    assert_equal "0.....", my_converter.get_next_char
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

  def test_converts_uppercase_characters
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

  def test_converts_a_single_number
    my_converter = BrailleConverter.new
    assert my_converter.is_num_shift?(".0.000")
    num = my_converter.convert_lines([".00...",".0....","00...."])
    assert_equal '1', num
    num = my_converter.convert_lines([".00...",".00...","00...."])
    assert_equal '2', num

  end

  def test_convert_multiple_numbers
    my_converter = BrailleConverter.new
    num = my_converter.convert_lines([".0000...",".0.0.0..","00......"])
    assert_equal '45', num
    num = my_converter.convert_lines([".00000..",".00.00..","00......"])
    assert_equal '67', num
    num = my_converter.convert_lines([".00..0.0..",".0000.00..","00........"])
    assert_equal '890', num
  end

  def test_convert_a_mix_of_letters_and_numbers
    my_converter = BrailleConverter.new
    mix_message = my_converter.convert_lines(["0...0..00...",".......0....","...0..00...."])
    assert_equal 'aA1', mix_message
    mix_message = my_converter.convert_lines( [".000....000.00.0",".0.......0...00.","00..........000."])
    assert_equal '3 days', mix_message
  end

end
