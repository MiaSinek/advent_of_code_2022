require 'minitest/autorun'

class TuningTrouble

  def initialize(signal)
    @signal = signal
  end

  def number_chars_before_first_start_of_packet_marker
    signal.split(packet_marker.join('')).first.length + 4 #packet_marker.length which we split by
  end

private

  attr_reader :signal

  def packet_marker
    packet_marker = []

    signal.each_char do |char|
      packet_marker << char

      packet_marker.shift if packet_marker.length >  packet_marker.uniq.length
      break if packet_marker.length == 4 && packet_marker.uniq.length == 4
    end
    packet_marker
  end
end

class TestTuningTrouble < Minitest::Test
  def test_number_chars_before_first_start_of_packet_marker
    assert_equal 5, TuningTrouble.new("bvwbjplbgvbhsrlpgdmjqwftvncz").number_chars_before_first_start_of_packet_marker
    assert_equal 6, TuningTrouble.new("nppdvjthqldpwncqszvftbrmjlhg").number_chars_before_first_start_of_packet_marker
    assert_equal 10, TuningTrouble.new("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").number_chars_before_first_start_of_packet_marker
    assert_equal 11, TuningTrouble.new("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").number_chars_before_first_start_of_packet_marker
  end
end

puts TuningTrouble.new(File.read("input.txt").chomp).number_chars_before_first_start_of_packet_marker
