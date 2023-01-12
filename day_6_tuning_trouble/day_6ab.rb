require 'minitest/autorun'

class TuningTrouble

  def initialize(signal:, chars_count_setting:)
    @signal = signal
    @chars_count_setting = chars_count_setting
  end

  def number_chars_before_first_start_of_packet_marker
    signal.split(packet_marker.join('')).first.length + chars_count_setting
  end

private

  attr_reader :signal, :chars_count_setting

  def packet_marker
    packet_marker = []

    signal.each_char do |char|
      packet_marker << char

      packet_marker.shift if packet_marker.length >  packet_marker.uniq.length
      break if packet_marker.length == chars_count_setting && packet_marker.uniq.length == chars_count_setting
    end
    packet_marker
  end
end

class TestTuningTrouble < Minitest::Test
  def test_number_chars_before_first_start_of_packet_marker
    assert_equal 5, TuningTrouble.new(signal: "bvwbjplbgvbhsrlpgdmjqwftvncz", chars_count_setting: 4).number_chars_before_first_start_of_packet_marker
    assert_equal 6, TuningTrouble.new(signal: "nppdvjthqldpwncqszvftbrmjlhg", chars_count_setting: 4).number_chars_before_first_start_of_packet_marker
    assert_equal 10, TuningTrouble.new(signal: "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", chars_count_setting: 4).number_chars_before_first_start_of_packet_marker
    assert_equal 11, TuningTrouble.new(signal: "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", chars_count_setting: 4).number_chars_before_first_start_of_packet_marker

    assert_equal 19, TuningTrouble.new(signal: "mjqjpqmgbljsphdztnvjfqwrcgsmlb", chars_count_setting: 14).number_chars_before_first_start_of_packet_marker
    assert_equal 23, TuningTrouble.new(signal: "bvwbjplbgvbhsrlpgdmjqwftvncz", chars_count_setting: 14).number_chars_before_first_start_of_packet_marker
    assert_equal 23, TuningTrouble.new(signal: "nppdvjthqldpwncqszvftbrmjlhg", chars_count_setting: 14).number_chars_before_first_start_of_packet_marker
    assert_equal 29, TuningTrouble.new(signal: "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", chars_count_setting: 14).number_chars_before_first_start_of_packet_marker
    assert_equal 26, TuningTrouble.new(signal: "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", chars_count_setting: 14).number_chars_before_first_start_of_packet_marker
  end
end

puts TuningTrouble.new(signal: File.read("input.txt").chomp, chars_count_setting: 4).number_chars_before_first_start_of_packet_marker
puts TuningTrouble.new(signal: File.read("input.txt").chomp, chars_count_setting: 14).number_chars_before_first_start_of_packet_marker
