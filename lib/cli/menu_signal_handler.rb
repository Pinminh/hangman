class MenuSignalHandler
  attr_reader :cli

  def initialize(cli)
    @cli = cli
  end

  def handle_signal(signal)
    case signal
    when :new_game then cli.main_instructor.play_game(reset: true)
    when :continue then do_continue_game
    when :load_game then cli.load_menu.display
    when :load_list then do_load_game_list
    when :unpause then cli.main_instructor.play_game
    when :save_game_on_pause then do_save_game_on_pause
    when :save_game_on_end then do_save_game_on_end
    when :start_menu then cli.start_menu.display
    when :settings then cli.settings_menu.display
    when :quit then cli.quit_panel.display
    end
  end

  private

  def do_continue_game
    game_hist = cli.hangman.game.class.pull_file_history

    return cli.main_instructor.play_game(reset: true) if game_hist.empty?

    last_save = game_hist.last
    last_game = cli.hangman.game.class.load_game last_save[:name]
    cli.hangman.game = last_game

    cli.main_instructor.play_game
  end

  def do_load_game_list
    saves_history = cli.hangman.game.class.pull_file_history
    return cli.load_menu.display_no_saves if saves_history.empty?

    cli.load_menu.display_list saves_history
  end

  def do_save_game_on_pause
    cli.main_displayer.display

    do_save_game ask_save_name(from: :pause)

    cli.main_displayer.display
    display_save_window

    cli.main_displayer.display
    cli.pause_menu.display
  end

  def do_save_game_on_end
    cli.end_menu.display(display_only: true)

    do_save_game ask_save_name(from: :end)

    cli.end_menu.display(display_only: true)
    display_save_window

    cli.end_menu.display
  end

  def do_save_game(save_name)
    game = cli.hangman.game
    game.class.save_game game, save_name
  end

  def display_save_window
    save_title = Rainbow('Save Game').bold.bright.gold
    CLI::UI::Frame.open(save_title, color: :yellow)

    spin_init = Rainbow('Saving current game...').bright.yellow
    spin_end = Rainbow('Complete successfully').bright.green
    CLI::UI::Spinner.spin(spin_init) do |spinner|
      sleep 1.0
      spinner.update_title(spin_end)
    end
    sleep 1.0

    CLI::UI::Frame.close nil
  end

  def ask_save_name(from: :pause)
    name = ''
    loop do
      cli.main_displayer.display if from == :pause
      cli.end_menu.display(display_only: true) if from == :end

      prompt = Rainbow('Enter save name:').bright.gold
      name = CLI::UI::Prompt.ask(prompt).strip

      if name.length > 16
        error = Rainbow('Name cannot exceed 16 characters').bright.red
        CLI::UI::Printer.puts error
        sleep 2
      end

      break if name.length <= 16
    end
    name
  end
end
