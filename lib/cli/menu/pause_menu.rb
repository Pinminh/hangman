class PauseMenu
  attr_reader :cli

  def initialize(cli)
    @cli = cli
  end

  def display
    pause_title = Rainbow('Pause Menu').bold.bright.crimson
    CLI::UI::Frame.open(pause_title, color: :red)

    prompt = Rainbow('You have paused the game').bold.bright.gold
    choice = CLI::UI::Prompt.ask(prompt, filter_ui: false) do |handler|
      handler.option('Unpause') { :unpause }
      handler.option('Save Game') { :save_game }
      handler.option('Restart') { :new_game }
      handler.option('Start Menu') { :start_menu }
    end

    CLI::UI::Frame.close nil

    cli.menu_handler.handle_signal choice
  end

  def display_saving
    save_name = ask_save_name
    game = cli.hangman.game
    game.class.save_game game, save_name

    cli.main_displayer.display
    display_save_window

    cli.main_displayer.display
    display
  end

  private

  def ask_save_name
    name = ''
    loop do
      cli.main_displayer.display

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
end
