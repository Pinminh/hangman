require 'cli/ui'
require 'rainbow/refinement'

# Display pause menu during guessing word
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
end
