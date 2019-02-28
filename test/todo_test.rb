require 'bundler/setup'
require 'simplecov'
require 'minitest/autorun'
require 'minitest/reporters'
require 'date'
Minitest::Reporters.use!
SimpleCov.start

require_relative '../lib/todo'

class TodoListTest < Minitest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Todays Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end
  
  def test_no_due_date
    assert_nil(@todo1.due_date)
  end
  
  def test_due_date
    due_date = Date.today + 3
    @todo2.due_date = due_date
    assert_equal(due_date, @todo2.due_date)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    todo = @list.shift

    assert_equal(@todo1, todo)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    todo = @list.pop

    assert_equal(@todo3, todo)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done?
    assert_equal(false, @list.done?)
  end

  def test_raise_add_other_object
    assert_raises(TypeError) { @list.add(1) }
  end

  def test_add
    new_todo = Todo.new("Wash the car")
    @list.add(new_todo)
    @todos << new_todo

    assert_equal(@todos, @list.to_a)
  end

  def test_shovel
    new_todo = Todo.new("Wash the car")
    @list << new_todo
    @todos << new_todo

    assert_equal(@todos, @list.to_a)
  end

  def test_item_at
    assert_raises(IndexError) { @list.item_at(5) }
    assert_equal(@todo1, @list.item_at(0))
    assert_equal(@todo2, @list.item_at(1))
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(5) }
    @list.mark_done_at(1)
    assert_equal(false, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(5) }
    @list.mark_all_done
    @list.mark_undone_at(1)
    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end

  def test_done!
    @list.done!
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(5) }
    @list.remove_at(0)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Todays Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_item_done
    output = <<~OUTPUT.chomp
    ---- Todays Todos ----
    [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    OUTPUT

    @list.mark_done_at(1)
    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
    output = <<~OUTPUT.chomp
    ---- Todays Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    @list.done!
    assert_equal(output, @list.to_s)
  end
  
  def test_to_s_with_due_date
    @todo2.due_date = Date.new(2017, 4, 15)
    output = <<~OUTPUT.chomp.gsub(/^\s+/, '')
    ---- Todays Todos ----
    [ ] Buy milk
    [ ] Clean room (Due: Saturday April 15)
    [ ] Go to gym
    OUTPUT
    
    assert_equal(output, @list.to_s)
  end

  def test_each
    result = []
    @list.each { |todo| result << todo }
    assert_equal([@todo1, @todo2, @todo3], result)
  end

  def test_each_return_value
    return_value = @list.each { |todo| todo }
    assert_equal(@list, return_value)
  end

  def test_select
    return_value = @list.select { |todo| true }
    assert_equal(return_value.class.to_s, "TodoList")
  end

  def test_find_by_title
    todo = @list.find_by_title("Buy milk")
    assert_equal(@todo1, todo)
  end

  def test_all_done
    @list.first.done!
    assert_equal([@todo1], @list.all_done.to_a)
  end

  def test_all_not_done
    @list.last.done!
    assert_equal([@todo1, @todo2], @list.all_not_done.to_a)
  end

  def test_mark_done_title
    @list.mark_done("Buy milk")
    assert_equal(true, @list.first.done?)
  end

  def test_mark_all_undone
    @list.mark_all_done
    @list.mark_all_undone
    assert_equal(false, @list.item_at(0).done?)
    assert_equal(false, @list.item_at(1).done?)
    assert_equal(false, @list.item_at(2).done?)
  end
end
