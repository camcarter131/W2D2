require "singleton"  
require 'byebug'

module Slideable
  def moves(dir)
    valid_moves = []
    #p pos

    start_piece = @board[pos]
    #p start_piece
    start = pos
    row = pos[0]
    col = pos[1]
    
    case dir
    when "hor"
      horizontal(row, col, start, start_piece, valid_moves)
    when "diag"
      diagonal(row, col, start, start_piece, valid_moves)
    when "both"
      horizontal(row, col, start, start_piece, valid_moves)
      diagonal(row, col, start, start_piece, valid_moves)
    end
    valid_moves    
  end

  def horizontal(row, col, start, start_piece, valid_moves)
    #slide up
    until row <= 0
      row -= 1
      curr_pos = [row, col]
      curr_piece = @board[curr_pos]
      if curr_piece.is_a?(NullPiece)  

        valid_moves << curr_pos
      elsif curr_piece.color == start_piece.color
        break
      else
        valid_moves << curr_pos
        break
      end
    end
    row, col = start

    #slide down
    until row >= 7
      row += 1
      curr_pos = [row, col]
      curr_piece = @board[curr_pos]
      if curr_piece.is_a?(NullPiece)
        valid_moves << curr_pos
      elsif curr_piece.color == start_piece.color
        break
      else
        valid_moves << curr_pos
        break
      end
    end
    row, col = start

    # slide left
    until col <= 0
      col -= 1
      curr_pos = [row, col]
      curr_piece = @board[curr_pos]
      if curr_piece.is_a?(NullPiece)
        valid_moves << curr_pos
      elsif curr_piece.color == start_piece.color
        break
      else
        valid_moves << curr_pos
        break
      end
    end
    row, col = start

    # slide right
    until col >= 7
      col += 1
      curr_pos = [row, col]
      curr_piece = @board[curr_pos]
      if curr_piece.is_a?(NullPiece)
        valid_moves << curr_pos
      elsif curr_piece.color == start_piece.color
        break
      else
        valid_moves << curr_pos
        break
      end
    end
  end

  def diagonal(row, col, start, start_piece, valid_moves)
    #down right
    until row == 7 || col == 7
      row += 1
      col += 1
      curr_pos = [row, col]
      curr_piece = @board[curr_pos]
      if curr_piece.is_a?(NullPiece)
        valid_moves << curr_pos
      elsif curr_piece.color == start_piece.color
        break
      else
        valid_moves << curr_pos
        break
      end
    end
    row, col = start

    #down left
    until row >= 7 || col <= 0
      row += 1
      col -= 1
      curr_pos = [row, col]
      curr_piece = @board[curr_pos]
      if curr_piece.is_a?(NullPiece)
        valid_moves << curr_pos
      elsif curr_piece.color == start_piece.color
        break
      else
        valid_moves << curr_pos
        break
      end
    end
    row, col = start

    # up right
    until row <= 0 || col >= 7
      row -= 1
      col += 1
      curr_pos = [row, col]
      curr_piece = @board[curr_pos]
      if curr_piece.is_a?(NullPiece)
        valid_moves << curr_pos
      elsif curr_piece.color == start_piece.color
        break
      else
        valid_moves << curr_pos
        break
      end
    end
    row, col = start

    #up left
    until row <= 0 || col <= 0
      row -= 1
      col -= 1
      curr_pos = [row, col]
      curr_piece = @board[curr_pos]
      if curr_piece.is_a?(NullPiece)
        valid_moves << curr_pos
      elsif curr_piece.color == start_piece.color
        break
      else
        valid_moves << curr_pos
        break
      end
    end
  end
end

module Stepable
  def moves

    valid_moves = []
    start_piece = @board[pos]

    start = pos
    row = pos[0]
    col = pos[1]

    debugger
    case type
    when "K"
      debugger
      valid_step(start_piece, [row+1, col+1], valid_moves)
      valid_step(start_piece, [row+1, col-1], valid_moves)
      valid_step(start_piece, [row-1, col-1], valid_moves)
      valid_step(start_piece, [row-1, col+1], valid_moves)
      valid_step(start_piece, [row+1, col], valid_moves)
      valid_step(start_piece, [row-1, col], valid_moves)
      valid_step(start_piece, [row, col+1], valid_moves)
      valid_step(start_piece, [row, col-1], valid_moves)
    when "N"
      valid_step(start_piece, [row+2, col+1], valid_moves)
      valid_step(start_piece, [row+2, col-1], valid_moves)
      valid_step(start_piece, [row-2, col+1], valid_moves)
      valid_step(start_piece, [row-2, col-1], valid_moves)
      valid_step(start_piece, [row+1, col+2], valid_moves)
      valid_step(start_piece, [row+1, col-2], valid_moves)
      valid_step(start_piece, [row-1, col+2], valid_moves)
      valid_step(start_piece, [row-1, col-2], valid_moves)
    end
    valid_moves
  end

  def valid_step(piece, end_pos, valid_moves)
    end_row, end_col = end_pos
    end_piece = @board[end_pos]
    if (end_piece.is_a?(NullPiece) || end_piece.color != piece.color) && end_row.between?(0,7) && end_col.between?(0,7)
      valid_moves << end_pos
    end
  end

end

class Piece
  attr_accessor :color, :type, :pos

  def initialize(color, type, pos, board)
    @color = color
    @type = type
    @pos = pos
    @board = board
  end

  def moves

  end

end

class NullPiece < Piece
  include Singleton
  def initialize
    @type = "-"
  end


end

class Bishop < Piece
  include Slideable

  attr_reader :dir
  
  def initialize(color, type, pos, board)
    @dir = "diag"
    super(color, type, pos, board)
  end

  def move_dirs
    dir
  end

end

class Rook < Piece
  include Slideable

  attr_reader :dir
  
  def initialize(color, type, pos, board)
    @dir = "hor"
    super(color, type, pos, board)
  end

  def move_dirs
    dir
  end

end

class Queen < Piece
  include Slideable

  attr_reader :dir
  
  def initialize(color, type, pos, board)
    @dir = "both"
    super(color, type, pos, board)
  end

  def move_dirs
    dir
  end
end

class Knight < Piece
  include Stepable
  attr_reader :dir
  
  def initialize(color, type, pos, board)
    super(color, type, pos, board)
  end

end

class King < Piece
  include Stepable

  attr_reader :dir
  
  def initialize(color, type, pos, board)
    super(color, type, pos, board)
  end

end

class Pawn < Piece
  attr_reader :dir
  
  def initialize(color, type, pos, board)
    super(color, type, pos, board)
  end

  def moves # board[[2,1]] board[pos] pos = [2,1]
    valid_moves = []
    start_pos = pos
    row, col = pos
    debugger
    if color == :white
      next_square = @board[[row+1,col]]
      if next_square.is_a?(NullPiece)
        valid_moves << [row+1, col]
        valid_moves << [row+2, col] if row == 1 && @board[[row+2,col]].is_a?(NullPiece)
      end
      up_left_square = @board[[row+1,col+1]]
      up_right_square = @board[[row+1,col-1]]
      valid_moves << [row+1, col+1] if !up_left_square.is_a?(NullPiece) && up_left_square.color != :white 
      valid_moves << [row+1, col-1] if !up_right_square.is_a?(NullPiece) && up_right_square.color != :white
    elsif color == :black
      next_square = @board[[row-1,col]]
      if next_square.is_a?(NullPiece)
        valid_moves << [row-1, col]
        valid_moves << [row-2, col] if row == 6 && @board[[row-2,col]].is_a?(NullPiece)
      end
      up_left_square = @board[[row-1,col+1]]
      up_right_square = @board[[row-1,col-1]]
      valid_moves << [row-1, col+1] if !up_left_square.is_a?(NullPiece) && up_left_square.color != :black
      valid_moves << [row-1, col-1] if !up_right_square.is_a?(NullPiece) && up_right_square.color != :black    
    end

    valid_moves
  end

end


