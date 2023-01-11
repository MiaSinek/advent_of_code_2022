require 'minitest/autorun'

class StackParser
  def initialize(stack_input)
    @stack_input = stack_input
    @stack_rows = stack_rows
  end

  def stack_columns
    raw_stack_columns = transpose_stack_rows
    remove_empty_crates_from(raw_stack_columns)
  end

  private

  attr_reader :stack_input, :stack_row

  def transpose_stack_rows
    rows = stack_rows.size
    columns = stack_rows.max_by(&:size).size

    raw_stack_columns = Array.new(columns) { Array.new(rows) }

    stack_rows.each_with_index do |row, i|
      row.each_with_index do |crate, j|
        raw_stack_columns[j][i] = crate
      end
    end

    raw_stack_columns
  end

  def remove_empty_crates_from(raw_stack_columns)
    raw_stack_columns.map do |column|
      column.delete_if { |crate| crate.nil? || crate.empty? }
    end
  end

  def stack_rows
    stack_input.map do |row|
      row.each_char.each_slice(4).map do |crate|
        crate.join('')
             .gsub("[", "")
             .gsub("]","")
             .strip
      end
    end
  end
end

class TestStackParser < MiniTest::Test
  def test_intial_stack_setup
    stack_input2 =[
      "[N]     [Q]         [N]\n",
      "[R]     [F] [Q]     [G] [M]\n",
      "[J]     [Z] [T]     [R] [H] [J]\n",
      "[T] [H] [G] [R]     [B] [N] [T]\n",
      "[Z] [J] [J] [G] [F] [Z] [S] [M]\n",
      "[B] [N] [N] [N] [Q] [W] [L] [Q] [S]\n",
      "[D] [S] [R] [V] [T] [C] [C] [N] [G]\n",
      "[F] [R] [C] [F] [L] [Q] [F] [D] [P]\n",
    ]

    # Frist element is the top crate in the stack
    columns_in_stack2 = [
      ["N", "R", "J", "T", "Z", "B", "D", "F"],
      ["H", "J", "N", "S", "R"],
      ["Q", "F", "Z", "G", "J", "N", "R", "C"],
      ["Q", "T", "R", "G", "N", "V", "F"],
      ["F", "Q", "T", "L"],
      ["N", "G", "R", "B", "Z", "W", "C", "Q"],
      ["M", "H", "N", "S", "L", "C", "F"],
      ["J", "T", "M", "Q", "N", "D"],
      ["S", "G", "P"]]

    assert_equal columns_in_stack2, StackParser.new(stack_input2).stack_columns
  end
end
