class ComputerPlayer
  attr_reader :dictionary, :secret_word
  attr_accessor :candidate_words

  def initialize(dictionary)
    @dictionary = dictionary
    @candidate_words = dictionary
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    @secret_word.length
  end

  def check_guess(ch)
    indices = []
    @secret_word.chars.each_index do |i|
      indices << i if ch == @secret_word[i]
    end
    indices
  end

  def register_secret_length(length)
    @candidate_words.reject! {|word| word.length != length}
  end

  def guess(board)
    guessed = board.compact.uniq
    total_counts = Hash.new(0)
    @candidate_words.each do |word|
      word_count(word).each do |k, v|
        total_counts[k] += v unless guessed.include?(k)
      end
    end
    total_counts.max_by {|k, v| v}[0]
  end

  def word_count(word)
    counts = Hash.new(0)
    word.chars.each {|ch| counts[ch] += 1}
    counts
  end

  def handle_response(guess, indices)
    @candidate_words.reject! {|word| indices.any? {|i| (word[i] != guess)}}
    @candidate_words.reject! {|word| word.count(guess) != indices.length}
  end
end

class HumanPlayer
  def register_secret_length(length)
    puts "The secret word is #{length} letters long!"
  end

  def pick_secret_word
    puts "Pick a word. How long is it?"
    Integer(gets.chomp)
  end

  def guess(board)
    p board
    puts "Guess a letter!"
    gets.chomp
  end

  def check_guess(guess)
    puts "Player guessed #{guess}!"
    puts "Where is the letter located?"
    gets.chomp.split(",").map(&:to_i)
  end

  def handle_response(guess, indices)
    puts "Found #{guess} at #{indices}"
  end
end

class Hangman
  attr_reader :guesser, :referee, :board

  def initialize(options)
    @guesser = options[:guesser]
    @referee = options[:referee]
  end

  def setup
    length = @referee.pick_secret_word
    @guesser.register_secret_length(length)
    @board = Array.new(length)
  end

  def take_turn
    guess = @guesser.guess(@board)
    indices = @referee.check_guess(guess)
    update_board(guess, indices)
    @guesser.handle_response(guess, indices)
  end

  def update_board(guess, indices)
    indices.each {|i| @board[i] = guess}
  end

  def play
    turns = 0

    setup

    until turns > 10
      display
      turns += 1
      take_turn
      if @board.all?
        puts "It is finished."
        return nil
      end
    end

    puts "Failed!"
  end

  def display
    puts @board.to_s
  end
end

if $PROGRAM_NAME == __FILE__
  puts "Would you like to be the guesser? (yes/no)"
  if gets.chomp == "yes"
    referee = ComputerPlayer.new(File.readlines("dictionary.txt").map(&:chomp))
    guesser = HumanPlayer.new
  else
    referee = HumanPlayer.new
    guesser = ComputerPlayer.new(File.readlines("dictionary.txt").map(&:chomp))
  end
  Hangman.new({guesser: guesser, referee: referee}).play
end
