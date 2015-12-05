require 'pry'
require_relative 'file_helpers'
require_relative 'braille_converter'

class NightReader
  attr_reader :reader, :writer, :converter

  def initialize
    @reader = FileReader.new
    @writer = FileWriter.new
    @converter = BrailleConverter.new
  end

  def decode_braille_to_file
    braille = reader.read
    plain = decode_from_braille(braille)
    written_file = writer.write(plain)
    puts "Created '#{written_file}' containing #{plain.chomp.length} characters."
  end

  def decode_from_braille(input)
    merged_lines = merge_into_three_lines(input)
    converter.convert_lines(merged_lines)
  end

  def merge_into_three_lines(input)
    lines = input.split("\n")
    if lines.length % 3 == 0
      merged_lines = ['','','']
      (0...lines.length/3).each do |i|
        (0..2).each {|j| merged_lines[j] << lines[i*3+j]}
      end
      merged_lines
    else
      nil
    end
  end

end


if __FILE__ == $0
  night_reader = NightReader.new
  night_reader.decode_braille_to_file
end
