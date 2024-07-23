require 'cli/ui'
require 'rainbow/refinement'

class MainDisplayer
  attr_reader :cli

  def initialize(cli)
    @cli = cli

    @keyboard = [('A'..'I').to_a, ('J'..'R').to_a, ('S'..'Z').to_a, ['PAUSE']]
    @cursor = { row: 0, col: 0 }
  end

  def display
    action_title = Rainbow('Guessing...').bold.bright.crimson

    CLI::UI::Frame.open(action_title, color: :red)
    CLI::UI::Printer.puts "TRIES: #{lives_box_bar}"

    CLI::UI::Frame.open(current_guess, color: :yellow)
    display_keyboard

    CLI::UI::Frame.close nil
    CLI::UI::Frame.close nil
  end

  def move_cursor(inc_row, inc_col)
    width = @keyboard[@cursor[:row]].length

    height = 3
    height = 4 if @cursor[:col].zero?
    height = 2 if @cursor[:col] == 8

    @cursor[:row] += inc_row
    @cursor[:col] += inc_col

    @cursor[:row] %= height
    @cursor[:col] %= width
  end

  def reset_cursor
    @cursor = { row: 0, col: 0 }
  end

  def value_on_cursor
    row_index = @cursor[:row]
    col_index = @cursor[:col]

    @keyboard[row_index][col_index].clone
  end

  private

  def lives_box_bar
    num_lives = cli.hangman.game.lives

    lives_color = :darkgreen
    lives_color = :orange if num_lives < 5
    lives_color = :red if num_lives < 3

    Rainbow("\u25A0\u25A0  " * num_lives).bright.color(lives_color)
  end

  def current_guess
    game = cli.hangman.game

    guess = game.current_guess.gsub('', ' ').strip.center 32
    guess.gsub!(/[a-z]/) { |letter| Rainbow(letter).bold.bright.gold }
    guess.gsub!('_', Rainbow('_').bold.bright.white)

    return game.hidden_word if game.correct_guess? || game.out_of_lives?

    guess
  end

  def display_keyboard
    @keyboard.each_with_index do |keyrow, row|
      print "\n| "
      keyrow.each_with_index do |key, col|
        print "#{styled_key(key, row, col)} | "
      end
      puts
    end
    nil
  end

  def styled_key(key, row, col)
    history = cli.hangman.game.history

    found_hist = history.find { |hist| hist[:guess] == key.downcase }
    on_cursor = row == @cursor[:row] && col == @cursor[:col]

    key = Rainbow(key).darkslategray
    key = key.underline.bright.white if on_cursor

    return key unless found_hist

    key = found_hist[:correct] ? key.green : key.red
    on_cursor ? key.bright.underline : key.faint
  end
end
