require 'minitest/autorun'

class CathodeRayTube

  def initialize(raw_intsructions)
    @raw_intsructions = raw_intsructions
  end

  def signal_strength
    x_register = 1
    cycle = 0
    signal_strength = 0

    raw_intsructions.map do |raw_intsruction|
      action, value = raw_intsruction.split(" ").map(&:chomp)

      if cycle % 40 == 20
        signal_strength += x_register * cycle
        p "signal_strength: #{signal_strength}, x_register: #{x_register}, cycle: #{cycle}"
      end

      # we need the x_register value in the cycle and not at the end of the cycle -> increasing the cycle num here
      cycle += 1

      case action
      when "noop"
        # no effect on x_register, takes 1 cycle to complete
      when "addx"
        # adds value to x_register, takes 2 cycle to complete
        if cycle % 40 == 20
          signal_strength += x_register * cycle
          p "signal_strength: #{signal_strength}, x_register: #{x_register}, cycle: #{cycle}"
        end
        x_register += value.to_i
        cycle += 1
      end
    end
    signal_strength
  end

private

  attr_reader :raw_intsructions
end

class TestCampCleanup < Minitest::Test
  def test_signal_strength
    raw_instructions = File.readlines("test_input.txt").map(&:chomp)

    assert_equal 13140, CathodeRayTube.new(raw_instructions).signal_strength
  end
end

#puts CampCleanup.new(File.readlines("input.txt").map(&:chomp)).number_of_fully_overlapping_pairs
