require 'cli/ui'
require 'rainbow/refinement'

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
      handler.option('Save Game') { :save_game_on_pause }
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
end
