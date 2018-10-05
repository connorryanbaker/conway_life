require 'colorize'
require_relative 'grid'

class Life 
  attr_accessor :grid 
  def initialize(rows, cols)
    @grid = Grid.new(rows, cols)
    play 
  end 
  
  def play 
    while true
      @grid.render
      @grid.configure_next
      @grid.swap_board
    end 
  end 
end 

Life.new(50,50).play
