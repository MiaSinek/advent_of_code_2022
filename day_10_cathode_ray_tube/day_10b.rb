require 'minitest/autorun'

class CathodeRayTube

  def initialize(raw_intsructions)
    @raw_intsructions = raw_intsructions
    @crt_screen = Array.new(6) { Array.new(40, "") }
  end

  def final_crt_screen
    filled_crt_screen.map {|screen_row| screen_row.join('')}
  end

  private

  attr_reader :raw_intsructions
  attr_accessor :crt_screen

  def filled_crt_screen
    x_register = 1
    cycle = 1

    raw_intsructions.map do |raw_intsruction|
      action, value = raw_intsruction.split(" ").map(&:chomp)

      #if noop or addx:
      # draw next pixel
      draw_pixel(x_register, cycle)

      cycle += 1 # increment cycle

      # if addx:
      if action == "addx"
        # draw next pixel
        draw_pixel(x_register, cycle)
        # add to x_register and increment cycle
        x_register += value.to_i
        cycle += 1
      end
    end
    @crt_screen
  end

  def curent_position_to_draw(x_register, cycle)
    row = (cycle - 1) / 40
    column = (cycle - 1) % 40

    [row, column]
  end

  def draw_pixel(x_register, cycle)
    draw_position = curent_position_to_draw(x_register, cycle)
    sprite_center_position = x_register

    if (draw_position[1] - sprite_center_position).abs <= 1
      @crt_screen[draw_position[0]][draw_position[1]] = "#"
    else
      @crt_screen[draw_position[0]][draw_position[1]] = "."
    end
  end
end

class TestCathodeRayTube < Minitest::Test
  def test_signal_strength
    raw_instructions = File.readlines("test_input.txt").map(&:chomp)

    final_screen = [
    "##..##..##..##..##..##..##..##..##..##..",
    "###...###...###...###...###...###...###.",
    "####....####....####....####....####....",
    "#####.....#####.....#####.....#####.....",
    "######......######......######......####",
    "#######.......#######.......#######....."
    ]

    assert_equal final_screen, CathodeRayTube.new(raw_instructions).final_crt_screen
  end
end

puts CathodeRayTube.new(File.readlines("input.txt").map(&:chomp)).final_crt_screen
