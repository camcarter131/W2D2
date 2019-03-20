require 'byebug'
require_relative "piece"
class Board
  
  attr_reader :grid

  def initialize
    piece_arr = ["R", "N", "B", "Q", "K", "B", "N", "R"]
    # debugger
    @grid = Array.new(8) { Array.new(8, NullPiece.instance) }
    [0,1,6,7].each do |row|
      (0..7).each do |col|
        if row == 0
          @grid[row][col] = Rook.new(:white, piece_arr[col], [row, col], self) if col == 0 || col == 7
          @grid[row][col] = Knight.new(:white, piece_arr[col], [row, col], self) if col == 1 || col == 6
          @grid[row][col] = Bishop.new(:white, piece_arr[col], [row, col], self) if col == 2 || col == 5
          @grid[row][col] = Queen.new(:white, piece_arr[col], [row, col], self) if col == 3
          @grid[row][col] = King.new(:white, piece_arr[col], [row, col], self) if col == 4
        elsif row == 1
          @grid[row][col] = Pawn.new(:white, "P", [row, col], self)
        elsif row == 6
          @grid[row][col] = Pawn.new(:black, "P", [row, col], self)
        else
          @grid[row][col] = Rook.new(:black, piece_arr[col], [row, col], self) if col == 0 || col == 7
          @grid[row][col] = Knight.new(:black, piece_arr[col], [row, col], self) if col == 1 || col == 6
          @grid[row][col] = Bishop.new(:black, piece_arr[col], [row, col], self) if col == 2 || col == 5
          @grid[row][col] = Queen.new(:black, piece_arr[col], [row, col], self) if col == 3
          @grid[row][col] = King.new(:black, piece_arr[col], [row, col], self) if col == 4
        end
      end
    end 
  end

  def [](pos)
    begin
      row, col = pos
      @grid[row][col]
    rescue StandardError => e
      puts "Enter valid position (0-7)"
    end
  end

  def []=(pos, piece)
    row, col = pos
    @grid[row][col] = piece
  end

  def move_piece(start_pos, end_pos)
    square1, square2 = self[start_pos], self[end_pos]
    if square1.is_a?(NullPiece)
      puts "Make sure that there is a piece at start position"
    else 
      if !square2.is_a?(NullPiece) && square1.color == square2.color
        puts "Invalid move"
      else
        # change later - can't take King
        self[end_pos] = square1
        ## assign the pos to the moved Piece
        self[end_pos].pos = end_pos
        self[start_pos] = NullPiece.instance
      end
    end
  end

  def valid_pos?(pos)
    pos.all? { |i| (0..7).to_a.include?(i) }
  end

end