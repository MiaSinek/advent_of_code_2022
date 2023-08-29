# pocket data: list and integers
# list: starts with [, ends with ], and contains zero or more comma-separated values - lists or integers
# each packet: a list, has own line

# The task essentially boils down to comparing two lists based on the described rules and determining if they are in the right order. Let's break down the problem:

#     Convert Integers to Lists: If we encounter an integer during the comparison, we should convert it into a list containing the integer. This simplifies the comparison rules since we now primarily deal with lists.

#     Recursively Compare Lists:
#         If both lists are empty, continue to the next part of the input.
#         If the left list is empty but the right isn't, the inputs are in the right order.
#         If the right list is empty but the left isn't, the inputs are not in the right order.
#         If the first elements of both lists are integers, compare them directly.
#           If the left integer is lower than the right integer, the inputs are in the right order.
#           If the left integer is higher than the right integer, the inputs are not in the right order.
#           Otherwise, the inputs are the same integer; continue checking the next part of the input.
#         If one of the elements is an integer and the other is a list, convert the integer to a list and recursively compare them.
#         If both elements are lists, recursively compare them.

require 'minitest/autorun'
require 'json'

class DistressSignal
  def initialize(list)
    @list = list
  end

  def sum_of_indices_of_pairs_that_are_in_right_order
    correct_indices = indices_of_correctly_ordered_pairs(signal_pairs)

    correct_indices.map { |i| i + 1 }.sum # Add 1 to each index to account for the 0-based index
  end

  private

  attr_reader :list

  def sanitized_list
    list.delete("")
    list
  end

  def signal_pairs
    @signal_pairs ||= sanitized_list.each_slice(2).to_a
  end

  def compare(left, right)

    # Convert integer inputs to lists
    left = Array(left)
    right = Array(right)

    left_elem, *left_remainder = left
    right_elem, *right_remainder = right

    return false if left == right # Base case: if both lists are the same move to the next pair

    # Base case: if either list is empty
    return true if left.empty? && !right.empty?
    return false if !left.empty? && right.empty?

    # Compare if both are integers
    if left_elem.is_a?(Integer) && right_elem.is_a?(Integer)
      return left_elem < right_elem || (left_elem == right_elem && compare(left_remainder, right_remainder))
    end

    # Convert integer to list if one is an integer and the other a list
    left_elem = Array(left_elem)
    right_elem = Array(right_elem)
    # Recursively compare lists
    compare_results = compare(left_elem, right_elem) || (left_elem == right_elem && compare(left_remainder, right_remainder))

    compare_results
  end

  # Count the correctly ordered pairs
  def indices_of_correctly_ordered_pairs(pairs)

    # If compare(left, right) returns true, the pair is kept. Otherwise, it is discarded.
    pairs.each_with_index.select do |pair, _|
      left, right = pair.map { |string| JSON.parse(string) }

      compare(left, right)
    end.map(&:last) # Return the indices of the kept pairs
  end
end

class TestDistressSignal < Minitest::Test
  def test_sum_of_indices_of_pairs_that_are_in_right_order
    list = ["[1,1,3,1,1]", "[1,1,5,1,1]", "", "[[1],[2,3,4]]", "[[1],4]", "", "[9]", "[[8,7,6]]", "", "[[4,4],4,4]", "[[4,4],4,4,4]", "", "[7,7,7,7]", "[7,7,7]", "", "[]", "[3]", "", "[[[]]]", "[[]]", "", "[1,[2,[3,[4,[5,6,7]]]],8,9]", "[1,[2,[3,[4,[5,6,0]]]],8,9]"]
    assert_equal 13, DistressSignal.new(list).sum_of_indices_of_pairs_that_are_in_right_order
  end
end

puts DistressSignal.new(File.readlines("input.txt").map(&:chomp)).sum_of_indices_of_pairs_that_are_in_right_order
