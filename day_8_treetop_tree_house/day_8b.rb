require 'minitest/autorun'

class TreehouseTreeTop

  def initialize(forest)
    @forest = forest
  end

  def highest_scenic_score
    highest_scenic_score = 0

    forest_matrix.each_with_index do |forest_row, row_index|
      forest_row.each_with_index do |tree, col_index|
        highest_scenic_score = [highest_scenic_score, scenic_score_for([row_index, col_index])].max
      end
    end
    highest_scenic_score
  end

private

  attr_reader :forest

  def forest_width
    forest.first.size
  end

  def forest_height
    forest.size
  end

  def scenic_score_for(tree_position)
    return 0 if tree_on_an_edge?(tree_position) # scenic score of trees on theedge of the forest is 0

    number_of_visible_trees_from_above(tree_position) *
    number_of_visible_trees_from_below(tree_position) *
    number_of_visible_trees_from_left(tree_position) *
    number_of_visible_trees_from_right(tree_position)
  end

  def tree_on_an_edge?(tree_position)
    row, col = tree_position

    row == 0 || row == forest_height - 1 || col == 0 || col == forest_width - 1
  end

  def number_of_visible_trees_from_above(tree_position)
    row, col = tree_position
    number_of_visible_trees = 0

    (row - 1).downto(0).each do |row_index|
      number_of_visible_trees += 1

      return number_of_visible_trees if forest_matrix[row_index][col] >= forest_matrix[row][col] # stop counting at the first view blocker -> a tree that is the same hieight or higher than a tree
    end
    number_of_visible_trees
  end

  def number_of_visible_trees_from_below(tree_position)
    row, col = tree_position
    number_of_visible_trees = 0

    (row + 1).upto(forest_height).each do |row_index|
      return number_of_visible_trees if forest_matrix[row_index].nil? # no more trees below - overflow

      number_of_visible_trees += 1

      return number_of_visible_trees if forest_matrix[row_index][col] >= forest_matrix[row][col]
    end
    number_of_visible_trees
  end

  def number_of_visible_trees_from_left(tree_position)
    row, col = tree_position
    number_of_visible_trees = 0

    (col - 1).downto(0).each do |col_index|
      number_of_visible_trees += 1

      return number_of_visible_trees if forest_matrix[row][col_index] >= forest_matrix[row][col]
    end
    number_of_visible_trees
  end

  def number_of_visible_trees_from_right(tree_position)
    row, col = tree_position
    number_of_visible_trees = 0

    (col + 1).upto(forest_width).each do |col_index|
      return number_of_visible_trees if forest_matrix[row][col_index].nil? # no more trees to the right - overflow

      number_of_visible_trees += 1

      return number_of_visible_trees if forest_matrix[row][col_index] >= forest_matrix[row][col]
    end
    number_of_visible_trees
  end

  def forest_matrix
    @_forest_matrix ||= forest.map do |row|
      row.chomp.split("").map(&:to_i)
    end
  end
end

class TestTreehouseTreeTop < Minitest::Test
  def test_highest_scenic_score
    forest = [
      "30373",
      "25512",
      "65332",
      "33549",
      "35390"
    ]

    assert_equal 8, TreehouseTreeTop.new(forest).highest_scenic_score
  end
end

puts TreehouseTreeTop.new(File.readlines("input.txt").map(&:chomp)).highest_scenic_score
