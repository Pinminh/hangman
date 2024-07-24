require_relative 'loadable'

class GameOperator
  extend Loadable

  attr_reader :hidden_word, :current_char, :max_lives, :lives,
              :num_wins, :num_plays

  def initialize(max_lives = 7)
    @max_lives = max_lives

    @num_wins = 0
    @num_plays = 0

    restart
  end

  def restart
    @hidden_word = self.class.load_random_word.freeze

    @current_char = nil
    @current_guess = '_' * @hidden_word.length
    @history = []

    @lives = @max_lives

    nil
  end

  def guess(char)
    char.downcase!

    raise "'#{char}' is not a character" unless char.is_a?(String) && char =~ /[a-z]/

    return false unless @lives.positive?
    return false if correct_guess?
    return false if chars_history.include? char

    update_state char
    update_score

    true
  end

  def out_of_lives?
    @lives <= 0
  end

  def correct_guess?
    @current_guess == @hidden_word
  end

  def at_start_state?
    return true if @current_char.nil?
    return true if @history.empty?
    return true if @current_guess.match?(/\A_+\Z/)

    false
  end

  def history
    @history.clone
  end

  def chars_history
    @history.map { |pair| pair[:guess] }
  end

  def current_guess
    @current_guess.clone
  end

  def max_lives=(max_lives)
    raise "lives #{max_lives} is not an integer" unless max_lives.is_a? Integer
    raise "lives #{max_lives} is not positive" unless max_lives.positive?
    raise 'the game is not in start state' unless at_start_state?

    @max_lives = max_lives
  end

  private

  def update_state(char)
    @current_char = char.freeze

    match_indices = (0...@hidden_word.length).find_all do |index|
      @hidden_word[index] == char
    end

    match_indices.each { |index| @current_guess[index] = char }

    char_correct = !match_indices.empty?

    @history << { guess: char, correct: char_correct }
    @lives -= 1 unless char_correct

    char_correct
  end

  def update_score
    @num_plays += 1 if correct_guess? || out_of_lives?
    @num_wins += 1 if correct_guess?
  end
end
