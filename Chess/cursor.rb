require "io/console"
require_relative "board"
require 'byebug'

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :cursor_pos, :board

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false # stops the console from printing return values

    STDIN.raw! # in raw mode data is given as is to the program--the system
                 # doesn't preprocess special characters such as control-c

    input = STDIN.getc.chr # STDIN.getc reads a one-character string as a
                             # numeric keycode. chr returns a string of the
                             # character represented by the keycode.
                             # (e.g. 65.chr => "A")

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil # read_nonblock(maxlen) reads
                                                   # at most maxlen bytes from a
                                                   # data stream; it's nonblocking,
                                                   # meaning the method executes
                                                   # asynchronously; it raises an
                                                   # error if no data is available,
                                                   # hence the need for rescue

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true # the console prints return values again
    STDIN.cooked! # the opposite of raw mode :)

    return input
  end

  def handle_key(key)
    # debugger
    case key 
    when :return || :space
      @cursor_pos
      # Refactor later
      #toggle_selected
    when :left
      update_pos(MOVES[:left])
      
    when :right
      return update_pos(MOVES[:right])
      
    when :up
      update_pos(MOVES[:up])
      
    when :down
      update_pos(MOVES[:down])
      
    when :ctrl_c 
      Process.exit(0) 
    end

  end

  def update_pos(diff)
    #debugger
    dup_pos = cursor_pos.dup

    [0,1].each { |i| dup_pos[i] += diff[i] } 
    if board.valid_pos?(dup_pos)
      @cursor_pos = dup_pos
      #board.cursor_pos = cursor_pos

      #return cursor_pos
      # debugger
    else
      puts "Moving to invalid position not allowed" 
      sleep(1)
    end

  end

  def toggle_selected 
      #@board[@cursor_pos].colorize(:red) if @board[@cursor_pos].color == :green
      #@board[@cursor_pos].colorize(:green) if @board[@cursor_pos].color == :red
      @board[@cursor_pos].type.colorize(:green)

    end
end