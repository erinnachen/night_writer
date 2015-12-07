require 'minitest'
require 'char_converter.rb'
require 'pry'

class CharConverterTest < Minitest::Test
  def test_looks_up_empty_string
    my_converter = CharConverter.new
    assert_equal "",my_converter.lookup_braille('')
  end

  def test_looks_up_space
    my_converter = CharConverter.new
    assert_equal '......',my_converter.lookup_braille(' ')
  end

  def test_looks_up_a_lowercase_letter
    my_converter = CharConverter.new
    assert_equal '0.....',my_converter.lookup_braille('a')
    assert_equal '0.0...',my_converter.lookup_braille('b')
    assert_equal '00....',my_converter.lookup_braille('c')
  end

  def test_looks_up_an_uppercase_letter
    my_converter = CharConverter.new
    assert_equal '.....00.....', my_converter.lookup_braille('A')
    assert_equal '.....00.0...', my_converter.lookup_braille('B')
    assert_equal '.....000....', my_converter.lookup_braille('C')
  end

  def test_looks_up_other_valid_characters
    my_converter = CharConverter.new
    assert_equal '..000.', my_converter.lookup_braille('!')
    assert_equal '....0.', my_converter.lookup_braille("'")
    assert_equal '..0...', my_converter.lookup_braille(',')
    assert_equal '....00', my_converter.lookup_braille('-')
    assert_equal '..00.0', my_converter.lookup_braille('.')
    assert_equal '..0.00', my_converter.lookup_braille('?')
  end

  def test_returns_empty_not_a_valid_char
    my_converter = CharConverter.new
    assert_equal "", my_converter.lookup_braille('$')
    assert_equal "", my_converter.lookup_braille('&')
    assert_equal "", my_converter.lookup_braille('*')
  end

  def test_lookup_not_a_single_char
    my_converter = CharConverter.new
    assert_equal "",my_converter.lookup_braille('ares')
    assert_equal "",my_converter.lookup_braille('boy')
    assert_equal "",my_converter.lookup_braille('cad')
  end

  def test_one_to_three
    my_converter = CharConverter.new
    assert_equal ["","",""], my_converter.one_to_three('')
    assert_equal ["","",""], my_converter.one_to_three('  ')
    assert_equal ["  ","  ","  "], my_converter.one_to_three('      ')
    assert_equal ["","",""], my_converter.one_to_three('aaa')
    assert_equal ["aa","aa","aa"], my_converter.one_to_three('aaaaaa')
    assert_equal ["aa","aa","aa"], my_converter.one_to_three('aaaaaabb')
    assert_equal ["aabb","aabb","aabb"], my_converter.one_to_three('aaaaaabbbbbb')
    assert_equal ["abghmn","cdijop","efklqr"], my_converter.one_to_three('abcdefghijklmnopqr')
  end

  def test_convert_char_empty_string
    my_converter = CharConverter.new
    assert_equal ["","",""],my_converter.convert_char('')
  end

  def test_convert_char_space
    my_converter = CharConverter.new
    assert_equal ["..","..",".."],my_converter.convert_char(' ')
  end

  def test_convert_char_lowercase
    my_converter = CharConverter.new
    assert_equal ["0.","..",".."],my_converter.convert_char('a')
    assert_equal ["0.","0.",".."],my_converter.convert_char('b')
    assert_equal ["00","..",".."],my_converter.convert_char('c')
    assert_equal ["00",".0",".."],my_converter.convert_char('d')
    assert_equal ["0.",".0",".."],my_converter.convert_char('e')
    assert_equal ["00","0.",".."],my_converter.convert_char('f')
    assert_equal ["00","00",".."],my_converter.convert_char('g')
    assert_equal ["0.","00",".."],my_converter.convert_char('h')
    assert_equal [".0","0.",".."],my_converter.convert_char('i')
  end

  def test_convert_char_uppercase
    my_converter = CharConverter.new
    assert_equal ["...0","..00",".0.."],my_converter.convert_char('J')
    assert_equal ["..0.","....",".00."],my_converter.convert_char('K')
    assert_equal ["..0.","..0.",".00."],my_converter.convert_char('L')
    assert_equal ["..00","....",".00."],my_converter.convert_char('M')
    assert_equal ["..00","...0",".00."],my_converter.convert_char('N')
    assert_equal ["..0.","...0",".00."],my_converter.convert_char('O')
    assert_equal ["..00","..0.",".00."],my_converter.convert_char('P')
    assert_equal ["..00","..00",".00."],my_converter.convert_char('Q')
    assert_equal ["..0.","..00",".00."],my_converter.convert_char('R')
  end

  def test_convert_char_other_valid_characters
    my_converter = CharConverter.new
    assert_equal ['..','00','0.'], my_converter.convert_char('!')
    assert_equal ['..','..','0.'], my_converter.convert_char("'")
    assert_equal ['..','0.','..'], my_converter.convert_char(',')
    assert_equal ['..','..','00'], my_converter.convert_char('-')
    assert_equal ['..','00','.0'], my_converter.convert_char('.')
    assert_equal ['..','0.','00'], my_converter.convert_char('?')
  end

  def test_convert_char_non_valid_characters
    my_converter = CharConverter.new
    assert_equal ["","",""], my_converter.convert_char('$')
    assert_equal ["","",""], my_converter.convert_char('&')
    assert_equal ["","",""], my_converter.convert_char('*')
  end

  def test_converts_not_a_single_char
    my_converter = CharConverter.new
    assert_equal ['0.','..','..'],my_converter.convert_char('ares')
    assert_equal ['0.','0.','..'],my_converter.convert_char('boy')
    assert_equal ['00','..','..'],my_converter.convert_char('cad')
    assert_equal ['..0.','....','.0..'],my_converter.convert_char('ARGH')
    assert_equal ['..0.','..0.','.0..'],my_converter.convert_char('BEEE')
    assert_equal ['..00','....','.0..'],my_converter.convert_char('Car')
  end

  def test_add_to_message
    my_converter = CharConverter.new
    assert_equal nil, my_converter.add_to_message('  ','hi ')
    assert_equal nil, my_converter.add_to_message([' '],['hi'])
    assert_equal ['','',''],my_converter.add_to_message(['','',''],['','',''])
    assert_equal ['..0.','..0.','..0.'],my_converter.add_to_message(['..','..','..'],['0.','0.','0.'])
    assert_equal ['a','b','c'],my_converter.add_to_message(['','',''],['a','b','c'])
    assert_equal ['a','b','c'],my_converter.add_to_message(['a','b','c'],['','',''])
    assert_equal ['adef','bghi','cjkl'],my_converter.add_to_message(['a','b','c'],['def','ghi','jkl'])
    assert_equal ['abcj','defk','ghil'],my_converter.add_to_message(['abc','def','ghi'],['j','k','l'])
  end

  def test_encode_empty_message
    my_converter = CharConverter.new
    out = my_converter.encode_message('')
    assert_equal ['','',''], out
  end

  def test_encode_message_single_letter
    my_converter = CharConverter.new
    out = my_converter.encode_message("a")
    assert_equal ["0.","..",".."], out
  end

  def test_encode_message_two_lowercase_letters
    my_converter = CharConverter.new
    out = my_converter.encode_message("ab")
    assert_equal ["0.0.","..0.","...."], out
  end

  def test_encode_message_one_uppercase_letter
    my_converter = CharConverter.new
    out = my_converter.encode_message("A")
    assert_equal ["..0.","....",".0.."], out
  end

  def test_encode_message_two_uppercase_letters
    my_converter = CharConverter.new
    out = my_converter.encode_message("AB")
    assert_equal ["..0...0.","......0.",".0...0.."], out
  end

  def test_encode_message_40_lowercase_letters
    my_converter = CharConverter.new
    out = my_converter.encode_message("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    assert_equal ["0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.","................................................................................","................................................................................"], out
  end

  def test_encode_message_41_lowercase_letters
    my_converter = CharConverter.new
    out = my_converter.encode_message("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
    assert_equal ["0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.","..................................................................................",".................................................................................."], out
  end

  def test_encode_message_all_characters
    my_converter = CharConverter.new
    out = my_converter.encode_message(" !',-.?abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    assert_equal ["..............0.0.00000.00000..0.00.0.00000.00000..0.00.0..000000...0...0...00..00..0...00..00..0....0...0..0...0...00..00..0...00..00..0....0...0..0...0....0..00..00..0.","..00..0...000...0....0.00.00000.00..0....0.00.00000.00..0.00...0.0......0........0...0..0...00..00..0...00......0........0...0..0...00..00..0...00......0...00.......0...0","..0.0...00.000....................0.0.0.0.0.0.0.0.0.0.0000.0000000.0...0...0...0...0...0...0...0...0...0...00..00..00..00..00..00..00..00..00..00..000.000.0.0.000.000.000"], out
  end

  def test_encode_message_invalid_characters
    skip
  end

  def test_switch_number_mode
    my_converter = CharConverter.new
    assert_equal false, my_converter.number_mode
    my_converter.switch_number_mode
    assert_equal true, my_converter.number_mode
    my_converter.switch_number_mode
    assert_equal false, my_converter.number_mode
  end

  def test_is_a_digit
    my_converter = CharConverter.new
    dig = my_converter.char_is_digit?('1')
    assert_equal true, dig
    dig = my_converter.char_is_digit?('2')
    assert_equal true, dig
    dig = my_converter.char_is_digit?('3')
    assert_equal true, dig
    dig = my_converter.char_is_digit?('a')
    assert_equal false, dig
    dig = my_converter.char_is_digit?('abcd')
    assert_equal false, dig
    dig = my_converter.char_is_digit?('134')
    assert_equal false, dig
  end

  def test_convert_a_single_number
    my_converter = CharConverter.new
    braille_num = my_converter.encode_message('1')
    assert_equal [".00...",".0....","00...."], braille_num
    braille_num = my_converter.encode_message('2')
    assert_equal [".00...",".00...","00...."], braille_num
    braille_num = my_converter.encode_message('3')
    assert_equal [".000..",".0....","00...."], braille_num
  end

  def test_convert_multiple_numbers
    my_converter = CharConverter.new
    braille_num = my_converter.encode_message('45')
    assert_equal [".0000...",".0.0.0..","00......"], braille_num
    braille_num = my_converter.encode_message('67')
    assert_equal [".00000..",".00.00..","00......"], braille_num
    braille_num = my_converter.encode_message('890')
    assert_equal [".00..0.0..",".0000.00..","00........"], braille_num
  end

  def test_convert_a_mix_of_letters_and_numbers
    my_converter = CharConverter.new
    mix_message = my_converter.encode_message('aA1')
    assert_equal ["0...0..00...",".......0....","...0..00...."], mix_message
    mix_message = my_converter.encode_message('3 days')
    assert_equal [".000....000.00.0",".0.......0...00.","00..........000."], mix_message
  end

end
