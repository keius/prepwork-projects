class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_play
    puts "Where would you like to attack?"
    pos = gets.chomp.split(",").map(&:to_i)
  end
end
