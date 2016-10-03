class Board
  attr_accessor :cells

  def initialize
    reset!
  end

  def reset!
    self.cells = Array.new(9, " ")
  end

  def display
    puts " #{cell_display(0)} | #{cell_display(1)} | #{cell_display(2)} "
    puts "-----------"
    puts " #{cell_display(3)} | #{cell_display(4)} | #{cell_display(5)} "
    puts "-----------"
    puts " #{cell_display(6)} | #{cell_display(7)} | #{cell_display(8)} "
  end

  def cell_display(cell_index)
    if cells[cell_index] == " "
      cell_index + 1
    else
      cells[cell_index]
    end
  end

  def position(position)
    cells[position.to_i - 1]
  end

  def full?
    cells.none? { |cell| cell == " "}
  end

  def turn_count
    cells.count { |cell| cell != " "}
  end

  def taken?(position)
    position(position) != " "
  end

  def valid_move?(position)
    position.to_i > 0 &&
      position.to_i < 10 &&
      !taken?(position)
  end

  def update(position, player)
    cells[position.to_i - 1] = player.token
  end
end