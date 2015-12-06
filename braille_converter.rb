require 'pry'

class BrailleConverter
  attr_reader :braille_to_char
  attr_accessor :br_message, :ind

  def initialize
    @braille_to_char = {"......" => " ", "0....." => "a", "0.0..." => "b", "00...." => "c", "00.0.." => "d", "0..0.." => "e", "000..." => "f", "0000.." => "g", "0.00.." => "h", ".00..." => "i", ".000.." => "j", "0...0." => "k", "0.0.0." => "l", "00..0." => "m", "00.00." => "n", "0..00." => "o", "000.0." => "p", "00000." => "q", "0.000." => "r", ".00.0." => "s", ".0000." => "t", "0...00" => "u", "0.0.00" => "v", ".000.0" => "w", "00..00" => "x", "00.000" => "y", "0..000" => "z", "..000." => "!", "....0." => "'", "..0..." => ",", "....00" => "-", "..00.0" => ".", "..0.00" => "?", ".....0" => "shift"}
  end

  def lookup_char(br_char)
    if br_char.empty?
      ''
    elsif br_char.length == 6 && braille_to_char.has_key?(br_char)
      braille_to_char[br_char]
    elsif br_char.length == 12 && br_char[0,6]==".....0"&& braille_to_char.has_key?(br_char[6,6])
      braille_to_char[br_char[6,6]].upcase
    else
      nil
    end
  end

  def three_to_one(br_inputs)
    if br_inputs.kind_of?(Array) && br_inputs.length == 3
      br_inputs.join("")
    else
      nil
    end
  end

  def convert_lines(input)
    load_br_message(input)
    message_out = ''
    while chars_left?
      br_char = get_next_char
      message_out << lookup_char(br_char)
    end
    message_out
  end

  def load_br_message(input)
    self.br_message= input
    self.ind= 0
  end

  def br_message_length
    br_message.empty? ? 0 : br_message[0].length
  end

  def get_next_char
    if chars_left?
      next_char = three_to_one(pull_char_from_message)
      next_char << three_to_one(pull_char_from_message) if is_shift?(next_char)
      next_char
    else
      nil
    end
  end

  def is_shift?(br_char)
    ".....0" == br_char
  end

  def chars_left?
    ind < br_message_length
  end

  def pull_char_from_message
    if chars_left?
      c = (0..2).map {|i| br_message[i][ind,2]}
      self.ind= ind+2
      c
    else
      nil
    end
  end

end
