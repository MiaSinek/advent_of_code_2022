require 'minitest/autorun'

class HillClimbing

  def initialize(heightmap)
    @heightmap = heightmap
  end

  def fewest_steps_required_to_reach_best_signal
    find_start_and_end_positions_for_heightmap
    set_height_for_start_and_end_positions

    count_steps_of_the_shortest_route_to_best_signal
  end

private

  def count_steps_of_the_shortest_route_to_best_signal
    queue = [@start_position]
    visited = {}
    steps = 0

    until queue.empty?
      queue_size = queue.size

      queue_size.times do
        current_position = queue.shift
        visited[current_position] = true
        return steps if current_position == @end_position
        #p "visited: #{visited}"
        queue += neighbors_of(current_position).reject {|neighbor| visited[neighbor] }.reject {|neighbor| queue.include?(neighbor)}
      end
      steps += 1
    end
    steps
  end

  attr_reader :heightmap

  def neighbors_of(position)
    row, col = position
    neighbors = []

    neighbors << [row - 1, col] if row > 0 && (number_heightmap[row - 1][col] <= number_heightmap[row][col] + 1) # checking neighbor above
    neighbors << [row + 1, col] if row < number_heightmap.size - 1 && (number_heightmap[row + 1][col] <= number_heightmap[row][col] + 1)# cheking neighbor below
    neighbors << [row, col - 1] if col > 0 && (number_heightmap[row][col - 1] <= number_heightmap[row][col] +1) # checking neighbor to the left
    neighbors << [row, col + 1] if col < number_heightmap[row].size - 1 && (number_heightmap[row][col + 1] <= number_heightmap[row][col] +1) # checking neighbor to the right

    neighbors
  end

  def heightmap_matrix
    @heightmap_matrix ||= heightmap.map {|row| row.split('') }
  end

  def number_heightmap
    @number_heightmap ||= heightmap_matrix.each_with_index do |row, row_idx|
      row.each_with_index do |cell, col_idx|
        heightmap_matrix[row_idx][col_idx] = cell.ord
      end
    end
    @number_heightmap
  end

  def find_start_and_end_positions_for_heightmap
    @start_position = nil
    @end_position = nil
    heightmap_matrix.each_with_index do |row, row_idx|
      row.each_with_index do |cell, col_idx|
        @start_position = [row_idx, col_idx] if cell == 'S'
        @end_position = [row_idx, col_idx] if cell == 'E'
      end
      break if @start_position && @end_position
    end
    [@start_position, @end_position]
  end

  def set_height_for_start_and_end_positions
    start_row, start_col = @start_position
    heightmap_matrix[start_row][start_col] = "a"

    end_row, end_col = @end_position
    heightmap_matrix[end_row][end_col] = "z"
  end
end

class TestHillClimbing < Minitest::Test
  def test_fewest_steps_required_to_reach_best_signal
    heightmap = [
      "Sabqponm",
      "abcryxxl",
      "accszExk",
      "acctuvwj",
      "abdefghi"
    ]
    assert_equal 31, HillClimbing.new(heightmap).fewest_steps_required_to_reach_best_signal
  end
end

puts HillClimbing.new(File.readlines("input.txt").map(&:chomp)).fewest_steps_required_to_reach_best_signal
