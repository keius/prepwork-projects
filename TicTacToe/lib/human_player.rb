class HumanPlayer
  attr_reader :name, :board
  attr_accessor :mark

  def initialize(name)
    @name = name
  end

  def get_move
    puts "Put mark where?"
    pos = gets.chomp.split(",").map(&:to_i)
  end

  def display(board)
    puts board.grid[0].to_s
    puts board.grid[1].to_s
    puts board.grid[2].to_s
  end
end
