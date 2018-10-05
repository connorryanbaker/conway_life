require 'colorize'
class Cell
  attr_accessor :row, :col, :living, :neighbors
  def initialize(row, col, living = false)
    @row, @col = row, col
    @living = living
    @neighbors = Array.new
  end

  def to_s
    if @living
      "  ".colorize(:background => :magenta)
    else
      "  ".colorize(:background => :light_green)
    end
  end
end
