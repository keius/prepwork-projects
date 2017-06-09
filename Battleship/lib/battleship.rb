require_relative "board"
require_relative "player"

class BattleshipGame
  attr_reader :player, :board

  def initialize(player, board = Board.new)
    @player = player
    @board = board
  end

  def attack(pos)
    if @board.empty?(pos)
      @board[pos] = :x
    else
      @board[pos] = :o
    end
  end

  def count
    @board.count
  end

  def game_over?
    @board.won? || @board.full?
  end

  def play_turn
    pos = player.get_play
    attack(pos)
  end

  def play
    rand(@board.grid.length - 1).times do
      @board.place_random_ship
    end

    until game_over?
      display_status
      play_turn
    end

    puts "You have won!"
  end

  def display_status
    system("clear")
    @board.display
    puts "There are #{count} ships remaining!"
  end
end

if $PROGRAM_NAME == __FILE__
  puts "What is your name!"
  player = HumanPlayer.new(gets.chomp)
  board = Board.new(Array.new(4) {Array.new(4)})
  BattleshipGame.new(player, board).play
end
