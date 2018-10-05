require 'colorize'
require_relative 'cell'

class Grid
  attr_reader :rows, :columns
  attr_accessor :board, :next, :neighbors

  def initialize(rows, columns)
    @rows, @columns = rows, columns
    @board = Array.new(@rows) { Array.new(@columns) }
    @next = Array.new(@rows) { Array.new(@columns) }
    insert_cells
  end

  def each_row
    @board.each do |row|
      yield row if row
    end
  end

  def each_cell
    each_row do |row|
      row.each do |cell|
        yield cell if cell
      end
    end
  end

  def [](row,col)
    return nil if !row.between?(0, @rows - 1)
    return nil if !col.between?(0, @columns - 1)
    @board[row][col]
  end

  def []=(row,col,value)
    return nil if !row.between?(0, @rows - 1)
    return nil if !col.between?(0, @columns - 1)
    @board[row][col] = value
  end

  def insert_cells
    @board.each_with_index do |row,ri|
      row.each_with_index do |col,ci|
        alive = (rand(1..5) == 3)
        @board[ri][ci] = Cell.new(ri, ci, alive)
      end
    end
    configure_neighbors
  end

  def configure_neighbors
    each_cell do |cell|
      row = cell.row
      col = cell.col
      self[row + 1, col].nil? ? cell.neighbors << [0, col] : cell.neighbors << [row + 1, col]
      self[row - 1, col].nil? ? cell.neighbors << [@rows - 1, col] : cell.neighbors << [row - 1, col]
      self[row, col + 1].nil? ? cell.neighbors << [row, 0] : cell.neighbors << [row, col + 1]
      self[row, col - 1].nil? ? cell.neighbors << [row, @columns - 1] : cell.neighbors << [row, col - 1]
      self[row - 1, col - 1].nil? ? cell.neighbors << [@rows - 1, @columns - 1] : cell.neighbors << [row - 1, col - 1]
      self[row - 1, col + 1].nil? ? cell.neighbors << [@rows - 1, 0] : cell.neighbors << [row - 1, col + 1]
      self[row + 1, col + 1].nil? ? cell.neighbors << [0,0] : cell.neighbors << [row + 1, col + 1]
      self[row + 1, col - 1].nil? ? cell.neighbors << [0, @columns - 1] : cell.neighbors << [row + 1, col - 1]
    end
  end

  def living_neighbors(cell)
    cell.neighbors.count {|pos| self[pos[0], pos[1]].living}
  end

  def configure_next
    each_cell do |cell|
      row, col = cell.row, cell.col
      if !cell.living && living_neighbors(cell) == 3
        @next[row][col] = Cell.new(row,col,true)
      elsif cell.living && living_neighbors(cell) < 2
        @next[row][col] = Cell.new(row,col)
      elsif cell.living && living_neighbors(cell) > 3
        @next[row][col] = Cell.new(row,col)
      elsif cell.living && (living_neighbors(cell) == 2 || 3)
        @next[row][col] = Cell.new(row,col,true)
      else
        @next[row][col] = Cell.new(row,col)
      end
    end
  end

  def render
    str = @board.map do |row|
      row.map {|cell| cell.to_s}.join("")
    end
    puts str
  end

  def swap_board
    @next.each_with_index do |row, ri|
      row.each_with_index do |col, ci|
        @board[ri][ci] = col
      end
    end
    @next = Array.new(@rows) { Array.new(@columns) }
    configure_neighbors
  end
end
