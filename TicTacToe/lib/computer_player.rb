class ComputerPlayer
  attr_reader :name, :board
  attr_accessor :mark

  def initialize(name)
    @name = name
  end

  def display(board)
    @board = board
  end

  def get_move
    moves = []
    (0..2).each do |row|
      (0..2).each do |col|
        pos = [row, col]
        moves << pos if @board.empty?(pos)
      end
    end

    moves.each do |move|
      @board.place_mark(move, mark)
      if @board.winner
        @board[move] = nil
        return move
      else
        @board[move] = nil
        next
      end
    end

    return moves.sample
  end
end
