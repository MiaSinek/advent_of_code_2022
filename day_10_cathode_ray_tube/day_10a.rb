require 'minitest/autorun'

class CathodeRayTube

  def initialize(raw_intsructions)
    @raw_intsructions = raw_intsructions
  end

  attr_reader :raw_intsructions

  def signal_strength
    x_register = 1
    cycle = 1
    signal_strength = 0

    raw_intsructions.map do |raw_intsruction|
      action, value = raw_intsruction.split(" ").map(&:chomp)

      #if noop or addx:
      # check signal strength
      if cycle % 40 == 20
        signal_strength += x_register * cycle
      end

      cycle += 1 # increment cycle

      # if addx:
      if action == "addx"
        # check signal strength
        if cycle % 40 == 20
          signal_strength += x_register * cycle
        end
        # add to x and increment cycle
        x_register += value.to_i
        cycle += 1
      end
    end
    signal_strength
  end
end

class TestCathodeRayTube < Minitest::Test
  def test_signal_strength
    raw_instructions = File.readlines("test_input.txt").map(&:chomp)

    assert_equal 13140, CathodeRayTube.new(raw_instructions).signal_strength
  end
end

puts CathodeRayTube.new(File.readlines("input.txt").map(&:chomp)).signal_strength
