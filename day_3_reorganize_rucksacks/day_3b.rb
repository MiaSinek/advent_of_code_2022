require 'minitest/autorun'
require 'set'

class ElfBadge

  def initialize(elves)
    @elves = elves
    @elf_groups = elves.each_slice(3).to_a
  end

  def sum_of_priorities_of_group_badges
    raise "There are not enough elves to form groups of three" if elves.length % 3 != 0

    elf_groups.inject(0) do |sum, group|
      badge = badge_of(group)
      sum += priority_of(badge)
    end
  end

  private

  attr_reader :elves, :elf_groups

  def badge_of(group)
    first_set = group[0].chars.to_set
    second_set = group[1].chars.to_set
    third_set = group[2].chars.to_set

    badges = first_set.intersection(second_set).intersection(third_set).to_a

    return badges.first if badges.length == 1

    raise "Found more than one badge in this group: #{badges}" if badges.length > 1
    raise "Found no badge for this group: #{group}" if badges.length == 0
  end

  def priority_of(badge)
    if badge >= "a" && badge <= "z"
      badge.ord - "a".ord + 1
    elsif badge >= "A" && badge <= "Z"
      badge.ord - "A".ord + 27
    else
      raise "Common item is an invalid character: #{badge}"
    end
  end
end

class TestElfBadge < Minitest::Test
  def test_sum_of_priorities_of_group_badges
    assert_equal 18, ElfBadge.new(["vJrwpWtwJgWrhcsFMMfFFhFp","jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL","PmmdzqPrVvPwwTWBwg"]).sum_of_priorities_of_group_badges
    assert_equal 52, ElfBadge.new(["wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn","ttgJtRGJQctTZtZT","CrZsJsPPZsGzwwsLwLmpwMDw"]).sum_of_priorities_of_group_badges
    assert_equal 70, ElfBadge.new(["wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn","ttgJtRGJQctTZtZT","CrZsJsPPZsGzwwsLwLmpwMDw","vJrwpWtwJgWrhcsFMMfFFhFp","jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL","PmmdzqPrVvPwwTWBwg"]).sum_of_priorities_of_group_badges
  end
end

puts ElfBadge.new(File.readlines("input.txt").map(&:chomp)).sum_of_priorities_of_group_badges
