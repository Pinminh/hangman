class EndMenu
  attr_reader :cli

  def initialize(cli)
    @cli = cli
  end

  def display(display_only: false)
    cli.clear_terminal

    action_title = Rainbow('Guess Result').bold.bright.crimson

    CLI::UI::Frame.open(action_title, color: :red)
    CLI::UI::Printer.puts "TRIES: #{cli.main_displayer.lives_box_bar}"

    CLI::UI::Frame.open(result_guess, color: :yellow)

    choice = ask_for_end_navigation unless display_only

    CLI::UI::Frame.close nil
    CLI::UI::Frame.close nil
    cli.menu_handler.handle_signal choice unless display_only
  end

  def display_saving
    display(display_only: true)
    cli.pause_menu.display_save_window

    display
  end

  private

  def result_guess
    game = cli.hangman.game
    return nil unless game.correct_guess? || game.out_of_lives?

    wrong_chars = []
    game.hidden_word.each_char.with_index do |char, index|
      wrong_chars.push char if game.current_guess[index] == '_'
    end

    result = game.current_guess.gsub('', ' ').strip.center 32
    result.gsub!(/[a-z]/) { |letter| Rainbow(letter).bold.bright.green }
    result.gsub!('_') { Rainbow(wrong_chars.delete_at(0)).bold.bright.red }

    result
  end

  def ask_for_end_navigation
    game = cli.hangman.game
    end_prompt = Rainbow(game.correct_guess? ? 'Congratulations :)' : 'Too Unlucky >:)')
    end_prompt = end_prompt.bold.bright.green
    end_prompt = end_prompt.red unless game.correct_guess?

    CLI::UI::Prompt.ask(end_prompt, filter_ui: false) do |handler|
      handler.option('Restart') { :new_game }
      handler.option('Save Game') { :save_game_on_end }
      handler.option('Start Menu') { :start_menu }
    end
  end
end
