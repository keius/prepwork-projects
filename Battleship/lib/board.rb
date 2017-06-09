class Board
  attr_reader :grid

  def self.default_grid
    Array.new(10) {Array.new(10)}
  end

  def initialize(grid = self.class.default_grid)
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

  def count
    @grid.flatten.compact.select {|el| el == :s}.length
  end

  def empty?(pos = nil)
    if pos
      self[pos].nil?
    else
      count == 0
    end
  end

  def full?
    @grid.flatten.none?(&:nil?)
  end

  def possible_positions
    positions = []
    (0..@grid.length - 1).each do |row|
      (0..@grid.length - 1).each do |col|
        positions << [row, col] if @grid[row][col].nil?
      end
    end
    positions
  end

  def place_random_ship
    pos = possible_positions.sample

    raise "Board full!" if full?

    until empty?(pos)
      pos = possible_positions.sample
    end

    self[pos] = :s
  end

  def won?
    count == 0
  end

  def display
    @grid.each do |row|
      puts display_row(row).to_s
    end
  end

  def display_row(arr)
    arr.map do |el|
      case el
      when nil
        :w
      when :s
        :w
      when :x
        :X
      when :o
        :O
      end
    end
  end

end
