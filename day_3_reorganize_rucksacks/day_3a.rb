require 'minitest/autorun'
require 'set'

class RucksackReorganizer

  def initialize(rucksacks)
    @rucksacks = rucksacks
  end

  def sum_of_priorities_of_common_items
    rucksacks.inject(0) do |sum, rucksack|
      common_item = common_item_in(rucksack)
      sum += priority_of(common_item)
    end
  end

  private

  attr_reader :rucksacks

  def first_compartment(rucksack)
    rucksack[0, rucksack.length / 2 ]
  end

  def second_compartment(rucksack)
    rucksack[rucksack.length / 2, rucksack.length]
  end

  def common_item_in(rucksack)
    first_set = first_compartment(rucksack).chars.to_set
    second_set = second_compartment(rucksack).chars.to_set

    common_items = first_set.intersection(second_set).to_a

    return common_items.first if common_items.length == 1

    raise "Found more than one common item in this rucksacks compartments: #{rucksack}" if common_items.length > 1
    raise "Found no common item in this rucksacks compartments: #{rucksack}" if common_items.length == 0
  end

  def priority_of(common_item)
    if common_item >= "a" && common_item <= "z"
      common_item.ord - "a".ord + 1
    elsif common_item >= "A" && common_item <= "Z"
      common_item.ord - "A".ord + 27
    else
      raise "Common item is an invalid character: #{common_item}"
    end
  end
end

class TestRucksackReorganizer < Minitest::Test
  def test_sum_of_priorities_of_common_items
    assert_equal 16, RucksackReorganizer.new(["vJrwpWtwJgWrhcsFMMfFFhFp"]).sum_of_priorities_of_common_items
    assert_equal 38, RucksackReorganizer.new(["jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL"]).sum_of_priorities_of_common_items # L has priority 38
    assert_equal 42, RucksackReorganizer.new(["PmmdzqPrVvPwwTWBwg"]).sum_of_priorities_of_common_items # P has priority 42
    assert_equal 22, RucksackReorganizer.new(["wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn"]).sum_of_priorities_of_common_items # v has priority 22
    assert_equal 20, RucksackReorganizer.new(["ttgJtRGJQctTZtZT"]).sum_of_priorities_of_common_items # t has priority 20
    assert_equal 19, RucksackReorganizer.new(["CrZsJsPPZsGzwwsLwLmpwMDw"]).sum_of_priorities_of_common_items # s has priority 19
    assert_equal 157,RucksackReorganizer.new(["vJrwpWtwJgWrhcsFMMfFFhFp", "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL", "PmmdzqPrVvPwwTWBwg", "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn", "ttgJtRGJQctTZtZT", "CrZsJsPPZsGzwwsLwLmpwMDw"]).sum_of_priorities_of_common_items # The sum of the priorities of p, L, P, v, t, and s
  end
end

puts RucksackReorganizer.new(File.readlines("input.txt").map(&:chomp)).sum_of_priorities_of_common_items
