require 'bundler/setup'
require 'stamp'

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '
  
  attr_accessor :title, :description, :done, :due_date
  
  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end
  
  def done!
    self.done = true
  end
  
  def done?
    done
  end
  
  def undone!
    self.done = false
  end
  
  def to_s
    result = "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
    result += due_date.stamp(' (Due: Friday January 6)') if due_date
    result
  end
end

class TodoList
  attr_accessor :title
  
  def initialize(title)
    @title = title
    @todos = []
  end
  
  
  def shift
    @todos.shift
  end
  
  def pop
    @todos.pop
  end
  
  def size
    @todos.size
  end
  
  def first
    @todos.first
  end
  
  def last
    @todos.last
  end
  
  def remove_at(index)
    @todos.delete(item_at(index))
  end
  
  def item_at(index)
    @todos.fetch(index)
  end
  
  def mark_done_at(index)
    item_at(index).done!
  end
  
  def mark_undone_at(index)
    item_at(index).undone!
  end
  
  def add(todo)
    if todo.class.to_s != "Todo"
      raise TypeError.new("Can only add Todo objects")
    end
    @todos << todo
    @todos
  end
  alias :<< :add
  
  def done?
    counter = 0
    
    while counter < @todos.size
      return false unless @todos[counter].done?
      counter += 1
    end
    
    true
  end
  
  def done!
    counter = 0
    
    while counter < @todos.size
      @todos[counter].done!
      counter += 1
    end
  end
  
  def find_by_title(string)
    select { |todo| string == todo.title }.first
  end
  
  def all_done
    select { |todo| todo.done? }
  end
  
  def all_not_done
    select { |todo| !todo.done? }
  end
  
  def mark_done(title)
    find_by_title(title) && find_by_title(title).done!
  end
  
  def mark_all_done
    each { |todo| todo.done! }
  end
  
  def mark_all_undone
    each { |todo| todo.undone! }
  end
  
  def each
    counter = 0
    
    while counter < @todos.size
      yield(@todos[counter])
      counter += 1
    end
    
    self
  end
  
  def select
    counter = 0
    list = TodoList.new(title)
    
    while counter < @todos.size
      current_element = @todos[counter]
      list << current_element if yield(current_element)
      counter += 1
    end
    
    list
  end
  
  def to_s
    counter = 0
    text = "---- #{title} ----\n"
    
    while counter < @todos.size
      text += "#{@todos[counter]}\n"
      counter += 1
    end
    
    text
  end
  
  def to_a
    @todos.to_a
  end
end

# given
todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
list = TodoList.new("Todos for Today")

# add
list.<<(todo1) # adds todo1 to end of list, returns list
list.<<(todo2) # adds todo2 to end of list, returns list
list.<<(todo3) # adds todo3 to end of list, returns list

#list.size
#list.first
#list.last
#list.to_a
#list.done?
#list.item_at
#list.item_at(1)
#list.item_at(100)
#list.mark_done_at
#list.mark_done_at(1)
#list.mark_done_at(100)
#list.mark_undone_at
#list.mark_undone_at(1)
#list.mark_undone_at(100)
#list.done!
#list.shift
#list.pop
#list.remove_at
#list.remove_at(1)
#list.remove_at(100)
#puts list

#list.each { |todo| puts todo }

#todo1.done!
#results = list.each { |todo| todo.done! }.select { |todo| todo.done? }
#puts results

#list.find_by_title("Buy milk")

#list.item_at(1).done!
#list.item_at(2).done!
#puts list.all_done

#puts list.all_not_done

#p list.mark_done("Buy milk")
#puts list
#p list.mark_done("this todo")

#list.mark_all_done
#puts list
#list.mark_all_undone
#puts list
