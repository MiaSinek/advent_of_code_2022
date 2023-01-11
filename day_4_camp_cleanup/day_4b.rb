require 'minitest/autorun'
require 'set'

class CampCleanup

  def initialize(elf_pairs)
    @elf_pairs = elf_pairs
  end

  def number_of_overlapping_pairs
    elf_pairs.inject(0) do |sum, elf_pair|
      sum += 1 if overlapping_pairs?(elf_pair)
      sum
    end
  end

private

  attr_reader :elf_pairs

  def overlapping_pairs?(elf_pair)
    overlap = first_elfs_section(elf_pair) & second_elfs_section(elf_pair)

    return true if overlap.any?
  end

  def section_to_be_cleaned(elf_pair, elf_index)
    from, to = elf_pair.split(",")[elf_index].split("-").map(&:to_i)

    (from..to).to_set
  end

  def first_elfs_section(elf_pair)
    section_to_be_cleaned(elf_pair, 0)
  end

  def second_elfs_section(elf_pair)
    section_to_be_cleaned(elf_pair, 1)
  end
end

class TestCampCleanup < Minitest::Test
  def test_number_of_overlapping_pairs
    elf_pairs = [
      "2-4,6-8",
      "2-3,4-5",
      "5-7,7-9",
      "2-8,3-7",
      "6-6,4-6",
      "2-6,4-8"
    ]
    assert_equal 4, CampCleanup.new(elf_pairs).number_of_overlapping_pairs
  end
end

puts CampCleanup.new(File.readlines("input.txt").map(&:chomp)).number_of_overlapping_pairs
