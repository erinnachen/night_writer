require 'minitest'

class NightWriterReaderTest < Minitest::Test
  def test_write_read_empty
    `rm empty_*.txt`
    `ruby night_write.rb empty.txt empty_write.txt`
    `ruby night_read.rb empty_write.txt empty_read.txt`
    assert_equal File.read("empty.txt"), File.read("empty_read.txt")
  end

  def test_write_read_hello_world
    `rm hello_world_*.txt`
    `ruby night_write.rb hello_world.txt hello_world_braille.txt`
    `ruby night_read.rb hello_world_braille.txt hello_world_from_braille.txt`
    assert_equal File.read("hello_world.txt"), File.read("hello_world_from_braille.txt")
  end

  def test_write_read_all_chars
    `rm all_chars_*.txt`
    `ruby night_write.rb all_chars.txt all_chars_braille.txt`
    `ruby night_read.rb all_chars_braille.txt all_chars_from_braille.txt`
    assert_equal File.read("all_chars.txt"), File.read("all_chars_from_braille.txt")
  end

  def test_read_write_empty
    `rm rempty_*.txt`
    `ruby night_read.rb rempty.txt rempty_read.txt`
    `ruby night_write.rb rempty_read.txt rempty_write.txt`
    assert_equal File.read("rempty.txt"), File.read("rempty_write.txt")
  end

  def test_read_write_hello_world
    `rm rhello_world_*.txt`
    `ruby night_read.rb rhello_world.txt rhello_world_read.txt`
    `ruby night_write.rb rhello_world_read.txt rhello_world_write.txt`
    assert_equal File.read("rhello_world.txt"), File.read("rhello_world_write.txt")
  end

  def test_read_write_all_chars
    `rm rall_chars_*.txt`
    `ruby night_read.rb rall_chars.txt rall_chars_read.txt`
    `ruby night_write.rb rall_chars_read.txt rall_chars_write.txt`
  end


end
