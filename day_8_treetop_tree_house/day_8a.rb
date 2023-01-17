require 'minitest/autorun'

class TreehouseTreeTop

  def initialize(forest)
    @forest = forest
  end

  def number_of_visible_trees
    forest_matrix.each_with_index.reduce(0) do |number_of_visible_trees, (forest_row, row_index)|
      number_of_visible_trees + forest_row.each_with_index.reduce(0) do |visible_trees_in_a_row, (tree, col_index)|
        visible_trees_in_a_row + (is_visible?([row_index, col_index]) ? 1 : 0)
      end
    end
  end

private

  attr_reader :forest

  def forest_width
    forest.first.size
  end

  def forest_height
    forest.size
  end

  def forest_matrix
    @_forest_matrix ||= forest.map do |row|
      row.chomp.split("").map(&:to_i)
    end
  end

  def is_visible?(tree_position)
    visible_from_above?(tree_position) ||
    visible_from_below?(tree_position) ||
    visible_from_left?(tree_position) ||
    visible_from_right?(tree_position)
  end

  def visible_from_above?(tree_position)
    row, col = tree_position

    (0..row - 1).each do |row_index|
      return false if forest_matrix[row_index][col] >= forest_matrix[row][col]
    end
  end

  def visible_from_below?(tree_position)
    row, col = tree_position

    (row + 1..forest_height).each do |row_index|
      return true if forest_matrix[row_index].nil? # no tree below
      return false if forest_matrix[row_index][col] >= forest_matrix[row][col]
    end
  end

  def visible_from_left?(tree_position)
    row, col = tree_position

    (0..col - 1).each do |col_index|
      return false if forest_matrix[row][col_index] >= forest_matrix[row][col]
    end
  end

  def visible_from_right?(tree_position)
    row, col = tree_position

    (col + 1..forest_width).each do |col_index|
      return true if forest_matrix[row][col_index].nil? # no tree on the right
      return false if forest_matrix[row][col_index] >= forest_matrix[row][col]
    end
  end
end

class TestTreehouseTreeTop < Minitest::Test
  def test_number_of_visible_trees
    forest = [
      "30373",
      "25512",
      "65332",
      "33549",
      "35390"
    ]

    assert_equal 21, TreehouseTreeTop.new(forest).number_of_visible_trees
  end
end

puts TreehouseTreeTop.new(File.readlines("input.txt").map(&:chomp)).number_of_visible_trees
