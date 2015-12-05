require "pry"
require_relative 'char_converter'
require_relative 'file_helpers'

class NightWriter
  attr_reader :reader, :writer, :converter, :max_chars

  def initialize(max_chars = 80)
    @reader = FileReader.new
    @writer = FileWriter.new
    @converter = CharConverter.new
    @max_chars = max_chars
  end

  def encode_file_to_braille
    plain = reader.read
    braille = encode_to_braille(plain)
    written_file = writer.write(braille)
    puts "Created '#{written_file}' containing #{plain.length} characters."
  end

  def encode_to_braille(input)
    braille_lines = converter.encode_message(input)
    parse_braille_lines(braille_lines)
  end

  def parse_braille_lines(b_lines)
    mlength = b_lines[0].length
    output_line = ''
    if mlength > 0
      ((mlength-1)/max_chars).times do
        (0..2).each do |i|
          output_line <<"#{b_lines[i][0, max_chars]}\n"
          b_lines[i] = b_lines[i][max_chars..-1]
        end
      end
      output_line <<"#{b_lines[0]}\n#{b_lines[1]}\n#{b_lines[2]}\n"
    end
    output_line
  end


end


if __FILE__ == $0
  night_writer = NightWriter.new
  night_writer.encode_file_to_braille
end
