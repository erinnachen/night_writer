require 'pry'

class BrailleConverter
  attr_reader :braille_to_char
  attr_accessor :br_message, :ind, :cap_mode, :num_mode

  def initialize
    @braille_to_char = {"......" => " ", "0....." => ["a","1"], "0.0..." => ["b","2"], "00...." => ["c","3"], "00.0.." => ["d","4"], "0..0.." => ["e","5"], "000..." => ["f","6"], "0000.." => ["g","7"], "0.00.." => ["h","8"], ".00..." => ["i","9"], ".000.." => ["j","0"], "0...0." => "k", "0.0.0." => "l", "00..0." => "m", "00.00." => "n", "0..00." => "o", "000.0." => "p", "00000." => "q", "0.000." => "r", ".00.0." => "s", ".0000." => "t", "0...00" => "u", "0.0.00" => "v", ".000.0" => "w", "00..00" => "x", "00.000" => "y", "0..000" => "z", "..000." => "!", "....0." => "'", "..0..." => ",", "....00" => "-", "..00.0" => ".", "..0.00" => "?"}
    @cap_mode = false
    @num_mode = false
  end

  def lookup_char(br_char)
    if br_char.empty?
      ''
    elsif braille_to_char.has_key?(br_char)
      char = braille_to_char[br_char]
      if char.kind_of?(Array)
        num_mode ? char = char[1] : char = char[0]
      end
      if cap_mode
        char = char.upcase
        switch_cap_mode
      end
      char
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
    # switch_num_mode if num_mode
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
      if is_shift?(next_char)
        switch_cap_mode
        next_char = three_to_one(pull_char_from_message)
      end
      if is_num_shift?(next_char)
        switch_num_mode
        next_char = three_to_one(pull_char_from_message)
      end
      if num_mode && is_space?(next_char)
        switch_num_mode
        chars_left? ? next_char = three_to_one(pull_char_from_message) : next_char = ''
      end
      next_char
    else
      nil
    end
  end

  def is_shift?(br_char)
    ".....0" == br_char
  end

  def is_space?(br_char)
    "......" == br_char
  end

  def is_num_shift?(br_char)
    ".0.000" == br_char
  end

  def switch_cap_mode
    self.cap_mode = !cap_mode
  end

  def switch_num_mode
    self.num_mode = !num_mode
  end

  def chars_left?
    ind < br_message_length
  end

  def pull_char_from_message
    if chars_left?
      c = (0..2).map {|i| br_message[i][ind,2]}
      self.ind= ind+2
      c
    end
  end

end

if __FILE__ == $0
  bc = BrailleConverter.new
  message = ['0...0.','......','...0..']
  bc.load_br_message(message)
  binding.pry
  puts bc.br_message
  puts bc.get_next_char

end
