class GameOperator
  MAX_LIVES = 8

  def initialize(hidden_word)
    @hidden_word = hidden_word

    @current_char = nil
    @current_guess = '_' * hidden_word.length
    @history = []

    @lives = MAX_LIVES
  end

  def guess(char)
    char.downcase!

    raise "'#{char}' is not a character" unless char.is_a?(String) && char =~ /[a-z]/

    return false unless @lives.positive?
    return false if correct_guess?
    return false if chars_history.include?(char)

    update_state(char)

    true
  end

  def restart(new_word)
    @hidden_word = new_word

    @current_char = nil
    @current_guess = '_' * new_word.length
    @history = []

    @lives = MAX_LIVES
  end

  def out_of_lives?
    @lives <= 0
  end

  def correct_guess?
    @current_guess == @hidden_word
  end

  def history
    @history.clone
  end

  def chars_history
    @history.map { |pair| pair[:guess] }
  end

  private

  def update_state(char)
    @current_char = char

    match_indices = (0...@hidden_word.length).find_all do |index|
      @hidden_word[index] == char
    end

    match_indices.each { |index| @current_guess[index] = char }

    char_correct = !match_indices.empty?

    @history << { guess: char, correct: char_correct }
    @lives -= 1 unless char_correct

    char_correct
  end
end
