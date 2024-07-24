require 'cli/ui'
require 'rainbow/refinement'

# Display settings menu
class SettingsMenu
  attr_reader :cli

  def initialize(cli)
    @cli = cli
  end

  def display
    cli.clear_terminal

    settings_title = Rainbow('Settings').bold.bright.crimson
    CLI::UI::Frame.open(settings_title, color: :red)

    settings_prompt = Rainbow('').bright.gold
    choice = CLI::UI::Prompt.ask(settings_prompt) do |handler|
      handler.option('Choose Difficulty') { :choose_difficulty }
      handler.option('Start Menu') { :start_menu }
      handler.option('Quit') { :quit }
    end

    CLI::UI::Frame.close nil
    cli.menu_handler.handle_signal choice
  end

  def display_difficulty
    settings_title = Rainbow('Settings').bold.bright.crimson
    CLI::UI::Frame.open(settings_title, color: :red)

    settings_prompt = Rainbow('Which difficulty do you want?').bright.gold
    num_tries = CLI::UI::Prompt.ask(settings_prompt) do |handler|
      handler.option('Easy (11 tries)') { 11 }
      handler.option('Standard (7 tries)') { 7 }
      handler.option('Hard (4 tries)') { 4 }
    end

    CLI::UI::Frame.close nil
    cli.hangman.game.max_lives = num_tries
    cli.hangman.game.restart
    cli.menu_handler.handle_signal :settings
  end
end
