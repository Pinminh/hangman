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
      handler.option('Choose Dictionary') { :choose_dictionary }
      handler.option('Start Menu') { :start_menu }
      handler.option('Quit') { :quit }
    end

    CLI::UI::Frame.close nil
    cli.menu_handler.handle_signal choice
  end

  def display_difficulty
    cli.clear_terminal

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

  def display_dictionary
    Dir.chdir 'resource'
    dictionary_names = Dir['*'].map { |name| name.delete_suffix '.txt' }
    Dir.chdir '../'

    cli.clear_terminal

    settings_title = Rainbow('Settings').bold.bright.crimson
    CLI::UI::Frame.open(settings_title, color: :red)

    settings_prompt = Rainbow('Which dictionary do you want?').bright.gold
    CLI::UI::Prompt.ask(settings_prompt) do |handler|
      dictionary_names.each do |dictionary_name|
        handler.option(dictionary_name) do
          path = "resource/#{dictionary_name}.txt"
          cli.hangman.game.class.load_dictionary path
        end
      end
    end

    CLI::UI::Frame.close nil
    cli.menu_handler.handle_signal :settings
  end
end
