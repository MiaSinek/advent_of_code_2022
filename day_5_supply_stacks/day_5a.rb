require 'minitest/autorun'
require 'set'
require_relative 'stack_parser'

class SupplyStack

  def initialize(stack_input:, instructions:)
    @stack_input = stack_input
    @instructions = instructions
  end

  def crate_ids_of_top_crates_in_final_stack_order
    final_stack_order.map(&:first).join
  end

private

  attr_reader :stack_input, :instructions

  def stacks
    @_stacks ||= StackParser.new(stack_input).stack_columns
  end

  def sanitize(instruction)
    # instruction format: "move 1 from 2 to 1" -> move 1 crate from stack 2 to stack 1
     instruction.scan(/\d+/).map(&:to_i)
  end

  def move_crates_based_on(sanitized_instruction)
    number_of_crates_to_move = sanitized_instruction[0]
    from_stack = sanitized_instruction[1] -1
    to_stack = sanitized_instruction[2] - 1

    crates_to_move = stacks[from_stack].shift(number_of_crates_to_move)

    stacks[to_stack].unshift(crates_to_move.reverse).flatten!
  end

  def final_stack_order
    # sanitized instructions contain: [number_of_crates_to_move, from_stack, to_stack]
    instructions.each do |instruction|
      sanitized_instruction = sanitize(instruction)
      move_crates_based_on(sanitized_instruction)
    end
    stacks
  end
end

class TestSupplyStack < Minitest::Test
  def test_final_stack_order
    stack_input = File.readlines("test_stack_order.txt")
    instructions = File.readlines("test_instructions.txt").map(&:chomp)

    assert_equal "CMZ", SupplyStack.new(stack_input: stack_input, instructions: instructions).crate_ids_of_top_crates_in_final_stack_order
  end
end

puts SupplyStack.new(stack_input: File.readlines("initial_stack.txt"), instructions: File.readlines("instructions.txt").map(&:chomp)).crate_ids_of_top_crates_in_final_stack_order
