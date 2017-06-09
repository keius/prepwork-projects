class Board
  attr_reader :grid

  def initialize(grid = Array.new(3) {Array.new(3)})
    @grid = grid
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  def empty?(pos)
    self[pos].nil?
  end

  def place_mark(pos, mark)
    self[pos] = mark
  end

  def winner
    (grid + col + diag).each do |triple|
      return :X if triple == [:X, :X, :X]
      return :O if triple == [:O, :O, :O]
    end
    nil
  end

  def col
    cols = Array.new(3) {Array.new(3)}
    (0..2).each do |row|
      (0..2).each do |col|
        cols[col][row] = @grid[row][col]
      end
    end
    cols
  end

  def diag
    diags = [[[0,0],[1,1],[2,2]], [[0,2],[1,1],[2,0]]]
    diags.map {|dia| dia.map {|row,col| @grid[row][col]}}
  end

  def over?
    winner || @grid.flatten.none?(&:nil?)
  end
end
