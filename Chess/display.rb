require 'colorize'
require_relative 'cursor'
require_relative 'board'
require 'byebug'
class Display

  attr_reader :board, :cursor

  def initialize(board)
    @board = board
    @cursor = Cursor.new([0,0], board)
  end
  
  def render
    board.grid.each_with_index do |row, i| 
      row.each_with_index do |piece, j| 

        disp_piece = piece.type + " "
        if [i, j] == cursor.cursor_pos
          print disp_piece.colorize(:red)
        else 
          print disp_piece
        end
      #puts
      end
      puts
    
    end
  end

  def move_cursor
    while true  
      system("clear") 
      render
      cursor.get_input
    end
  end

end

board = Board.new
d = Display.new(board)
d.move_cursor


