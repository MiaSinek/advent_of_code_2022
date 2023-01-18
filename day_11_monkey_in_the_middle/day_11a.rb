require 'minitest/autorun'

class MonkeyBusiness

  def initialize(raw_instructions)
    @raw_instructions = raw_instructions
  end

  def monkey_business_level_after_round(number)
    @monkey_data = get_input_monkey_data

    number.times do
      perform_round_for_all_monkeys
    end

    calculate_final_monkey_business_level
  end

  private

  attr_reader :raw_instructions

  def get_input_monkey_data
    @monkey_data = {}
    current_monkey = nil

    raw_instructions.each do |instruction|
      if instruction.start_with?("Monkey")
        current_monkey = instruction.scan(/\d+/).first
        @monkey_data[current_monkey] = {}
      elsif instruction.include?("Starting items:")
        @monkey_data[current_monkey]["items"] = instruction.split(":")[1].strip().split(",").map(&:to_i)
      elsif instruction.include?("Operation:")
        @monkey_data[current_monkey]["operation"] = instruction.split(":")[1].strip()
      elsif instruction.include?("Test:")
        @monkey_data[current_monkey]["divisor"] = instruction.split(":")[1].strip().scan(/\d+/).first.to_i
      elsif instruction.include?("If true:")
        @monkey_data[current_monkey]["if_divisible_throw_to_monkey"] = instruction.split(":")[1].strip().scan(/\d+/).first
      elsif instruction.include?("If false:")
        @monkey_data[current_monkey]["if_not_divisible_throw_to_monkey"] = instruction.split(":")[1].strip().scan(/\d+/).first
      end
      @monkey_data[current_monkey]["inspection_count"] = 0
    end
    @monkey_data
  end

  def perform_round_for_all_monkeys
    0.upto(monkey_count - 1).each do |monkey_id|
      monkey_id = monkey_id.to_s
      perform_round_for(monkey_id)
    end
  end

  def monkey_count
    @monkey_data.keys.count
  end

  def perform_round_for(monkey_id)
    item_stash_of(monkey_id).dup.each do |item|
      inspect_and_throw_item_from(monkey_id)
    end
  end

  def inspect_and_throw_item_from(monkey_id)
    item_worry_level = item_stash_of(monkey_id).first
    divisor = @monkey_data[monkey_id]["divisor"]
    item_updated_worry_level = update_worry_level(monkey_id, item_worry_level)

    if item_updated_worry_level % divisor == 0
      reciever_monkey = @monkey_data[monkey_id]["if_divisible_throw_to_monkey"]
      @monkey_data[reciever_monkey]["items"] << item_updated_worry_level
    else
      reciever_monkey = @monkey_data[monkey_id]["if_not_divisible_throw_to_monkey"]
      @monkey_data[reciever_monkey]["items"] << item_updated_worry_level
    end

    item_stash_of(monkey_id).shift
    @monkey_data[monkey_id]["inspection_count"] += 1
  end

  def update_worry_level(monkey_id, item_worry_level)
    old = item_worry_level
    eval(@monkey_data[monkey_id]["operation"]) / 3
  end

  def item_stash_of(monkey_id)
    @monkey_data[monkey_id]["items"]
  end

  def calculate_final_monkey_business_level
    monkey_activity_ladder.first(2).inject(1) do |monkey_business_level, monkey_data|
      monkey_business_level *= monkey_data[1]["inspection_count"]
    end
  end

  def monkey_activity_ladder
    @monkey_data.sort_by {|monkey_id, monkey_data| monkey_data["inspection_count"]}.reverse
  end
end

class TestMonkeyBusiness < Minitest::Test
  def test_monkey_business_level
    raw_instructions = File.readlines("test_input.txt")

    assert_equal 10605, MonkeyBusiness.new(raw_instructions).monkey_business_level_after_round(20)
  end
end

puts MonkeyBusiness.new(File.readlines("input.txt").map(&:chomp)).monkey_business_level_after_round(20)

# inspect item in a list (starting with the first item and going to the end of the list)
# set worry level (original worry leve * multiplier)
# decrease the worry level after monkey gets bored with the item -> worry_level / 3
# throw item to other monkey (based on criteria to which monkey it goes)

# monkeys are taking turns
# in each turn all items are inspected in list order
# items thrown end up at the end of the list of the receiving monkey