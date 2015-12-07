require 'pry'

class CharConverter
  attr_reader :char_to_braille
  attr_accessor :number_mode

  def initialize
    @char_to_braille = {" " => "......", "a" => "0.....", "b" => "0.0...", "c" => "00....", "d" => "00.0..","e" => "0..0..", "f" => "000...", "g" => "0000..", "h" => "0.00..", "i" => ".00...", "j" => ".000..", "k" => "0...0.", "l" => "0.0.0.", "m" => "00..0.", "n" => "00.00.", "o" => "0..00.", "p" => "000.0.", "q" => "00000.", "r" => "0.000.", "s" => ".00.0.", "t" => ".0000.", "u" => "0...00", "v" => "0.0.00", "w" => ".000.0", "x" => "00..00", "y" => "00.000", "z" => "0..000", "!" => "..000.", "'" => "....0.", "," => "..0...", "-" => "....00", "." => "..00.0", "?" => "..0.00", "1" => "0.....", "2" => "0.0...", "3" => "00....", "4" => "00.0..", "5" => "0..0..", "6" => "000...", "7" => "0000..", "8" => "0.00..", "9" => ".00...", "0" => ".000..", "shift" => ".....0", "num_shift" => ".0.000"}
    @number_mode = false
  end

  def lookup_braille(c)
    if char_to_braille.has_key?(c)
        char_to_braille[c]
    elsif char_to_braille.has_key?(c.downcase)
      char_to_braille["shift"]+char_to_braille[c.downcase]
    else
      ""
    end
  end

  def convert_char(c)
    c = c[0] if c.length > 1
    if char_is_digit?(c)
      if number_mode?
        one_to_three(lookup_braille(c))
      else
        switch_number_mode
        one_to_three(lookup_braille("num_shift")+lookup_braille(c))
      end
    else
      br_c = ''
      if number_mode?
        switch_number_mode
        br_c << lookup_braille(" ")
      end
      one_to_three(br_c << lookup_braille(c))
    end
  end

  def one_to_three(br)
    b3 = ['','','']
    (0...br.length/6).each do |i|
      b1 = br[6*i...6*(i+1)]
      (0..2).each {|j| b3[j] << b1[2*j,2] }
    end
    b3
  end

  def add_to_message(message, more_message)
    if is_valid_message?(message) && is_valid_message?(more_message)
      (0..2).each {|j| message[j] << more_message[j] }
      message
    end
  end

  def encode_message(input)
    encoded = ['','','']
    input.chars.each do |char|
      br_c = convert_char(char)
      encoded = add_to_message(encoded, br_c)
    end
    if number_mode?
      switch_number_mode
      add_to_message(encoded, one_to_three(lookup_braille(' ')))
    else
      encoded
    end
  end

  def is_valid_message?(message)
    message.kind_of?(Array) && message.length == 3
  end

  def switch_number_mode
    self.number_mode = !number_mode
  end

  def number_mode?
    number_mode
  end

  def char_is_digit?(dig)
    dig.length == 1 ? /\A\d+\z/ === dig : false
  end

end


if __FILE__ == $0
  cc = CharConverter.new
  puts cc.encode_message('45')
end
