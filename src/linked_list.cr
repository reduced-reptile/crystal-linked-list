# A linked list is a **Enumerable** (see the `Enumerable` module) data structure
# that stores multiple pieces of data in non contiguous locations in memory.
#
# To create a linked list:
#
# ```
# list = LinkedList(Int32).new
# list.push(2)
# list.pop
# ```
#
# The above produces:
#
# ```text
# 2
# ```
class LinkedList(A)
  include Enumerable(A | Nil)

  def initialize
    @head = Node(A).new
    @tail = @head
  end

  def initialize(*values)
    initialize(values)
  end

  def initialize(values : Enumerable(A))
    @head = Node(A).new
    @tail = @head
    values.each do |value|
      append(value)
    end
  end

  def append(value : A)
    new_node = Node(A).new(value)
    @tail.next = new_node
    @tail = new_node
    new_node.value
  end

  def append(*values)
    values.each do |value|
      append(value)
    end
  end

  def push(value : A)
    append(value)
  end

  def <<(value : A)
    append(value)
    self
  end

  def unshift(value : A)
    new_top = Node(A).new(value)
    if @tail == @head
      @tail = new_top
    end
    new_top.next = @head.next
    @head.next = new_top
    new_top.value
  end

  def shift
    return if @head.next.nil?

    first = @head.next.not_nil!
    @head.next = first.next
    first.value
  end

  def peek
    @tail.value
  end

  def pop
    return nil if @head == @tail

    last = @tail
    current = @head
    while current.next != last
      current = current.next.not_nil!
    end

    current.next = nil
    @tail = current
    last.value
  end

  def each
    each_node do |node|
      yield node.value
    end
    self
  end

  def +(list : Enumerable(C)) forall C
    LinkedList(A | C).new.tap do |new_list|
      each do |value|
        new_list.append(value)
      end
      list.each do |value|
        new_list.append(value)
      end
    end
  end

  def concat(list : LinkedList(A))
    @tail.next = list.head.next
    @tail = list.tail
    self
  end

  def empty?
    @head == @tail
  end

  def reverse
    LinkedList(A).new.tap do |new_list|
      each do |value|
        new_list.unshift(value.not_nil!)
      end
    end
  end

  protected def head
    @head
  end

  protected def tail
    @tail
  end

  private def each_node
    current = @head
    until current.next.nil?
      current = current.next.not_nil!
      yield current
    end
  end

  # A node is the building block of linked lists consisting of a values
  # and a pointer to the next node in the linked list.
  #
  # To create a node:
  #
  # ```
  # node = Node.new(5)
  # node.value
  # ```
  #
  # The above produces:
  #
  # ```text
  # 5
  # ```
  #
  # Check the value of the node with `#value`.
  # Get the next node in the list with `#next`.
  class Node(T)
    @next = nil
    @value = nil

    # Creates a node with no value.
    def initialize
    end

    # Creates a node with the specified *value*.
    def initialize(@value : T)
    end

    # Returns the value of the node
    #
    # ```
    # Node.new(1).value # => 1
    # ```
    def value
      @value
    end

    # Returns the next node in the linked list, or nil if it's the tail.
    #
    # ```
    # node = Node.new(1)
    # node.next = Node.new(2)
    # node.next.value # => 2
    # ```
    def next
      @next
    end

    # Sets the next node in the linked list to *next_node*
    #
    # ```
    # node = Node.new(1)
    # node.next = Node.new(2)
    # node.next.value # => 2
    # ```
    def next=(next_node : Node(T) | Nil)
      @next = next_node
    end
  end
end
