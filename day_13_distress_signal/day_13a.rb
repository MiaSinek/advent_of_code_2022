# pocket data: list and integers
# list: with [, ends with ], and contains zero or more comma-separated values - lists or integers
# eahc packet: a list, has own line

# left - right
# both integers: lower comes first
# both lists: compare values that have the same index -> lower should come first
#     if left runs out of values, it is the right order
#     if right runs out of values -> wrong order
#     if 1 integer and list: convert the integer into a list

require 'minitest/autorun'
require 'json'

class DistressSignal

  def initialize(list)
    @list = list
  end

  def sum_of_indices_of_pairs_that_are_in_right_order
    signal_pairs.each_with_index.inject(0) do |sum, (pair, index)|
      puts "evaluating signal pair #{pair}"
      p "index: #{index}"
      p "pair in order? #{pair_in_order?(pair)}"
      sum += (index + 1) if pair_in_order?(pair)
      p "sum after this pair: #{sum}"
      p "---------------------"
      sum
    end
  end

private

  attr_reader :list

  def sanitized_list
    list.delete("")
    sanitized_list = list
  end

  def signal_pairs
    @signal_pairs ||= sanitized_list.each_slice(2).to_a
  end

  def integers_in_order?(left, right)
    return false if left > right
    true
  end

  def array_to_integer_in_order?(left, right)
    return true if left[0].nil?

    if left[0].is_a?(Integer)
      return false if left[0] > right
    end

    if left[0].is_a?(Array)
      return false if !array_to_integer_in_order?(left[0], right)
    end

    true
  end

  def integer_to_array_in_order?(left, right)
    return false if right[0].nil?

    if right[0].is_a?(Integer)
      return false if left > right[0]
    end

    if right[0].is_a?(Array)
      return false if !integer_to_array_in_order?(left, right[0])
    end

    true
  end

  def arrays_in_order?(left, right)
    left.each_with_index do |left_value, index|
      return false if right[index].nil?

      if left_value.is_a?(Integer) && right[index].is_a?(Integer)
        return false if !integers_in_order?(left_value, right[index])
      end


      if left_value.is_a?(Array) && right[index].is_a?(Array)
        return false if !arrays_in_order?(left_value, right[index])
      end

      if left_value.is_a?(Array) && right[index].is_a?(Integer)
        return false if !array_to_integer_in_order?(left_value, right[index])
      end

      if left_value.is_a?(Integer) && right[index].is_a?(Array)
        return false if !integer_to_array_in_order?(left_value, right[index])
      end
    end
    true
  end

  def pair_in_order?(pair)
    left, right = pair.map { |string| JSON.parse(string) }
    p "left: #{left}"
    p "right: #{right}"
    return true if left == right # left and right are identical
    return true if left == []
    return false if right == []

    if left.is_a?(Integer) && right.is_a?(Integer)
      return false if !integers_in_order?(left, right)
    end

    if left.is_a?(Array) && right.is_a?(Array)
      return false if !arrays_in_order?(left, right)
    end

    if left.is_a?(Array) && right.is_a?(Integer)
      return false if !array_to_integer_in_order?(left, right)
    end

    if left.is_a?(Integer) && right.is_a?(Array)
      return false if !integer_to_array_in_order?(left, right)
    end

    true
  end
end

# class TestDistressSignal < Minitest::Test
#   def test_sum_of_indices_of_pairs_that_are_in_right_order
#     list = ["[1,1,3,1,1]", "[1,1,5,1,1]", "", "[[1],[2,3,4]]", "[[1],4]", "", "[9]", "[[8,7,6]]", "", "[[4,4],4,4]", "[[4,4],4,4,4]", "", "[7,7,7,7]", "[7,7,7]", "", "[]", "[3]", "", "[[[]]]", "[[]]", "", "[1,[2,[3,[4,[5,6,7]]]],8,9]", "[1,[2,[3,[4,[5,6,0]]]],8,9]"]
#     assert_equal 13, DistressSignal.new(list).sum_of_indices_of_pairs_that_are_in_right_order
#   end
# end

puts DistressSignal.new(File.readlines("input.txt").map(&:chomp)).sum_of_indices_of_pairs_that_are_in_right_order
