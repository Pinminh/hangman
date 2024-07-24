require 'cli/ui'
require 'rainbow/refinement'

class SettingsMenu
  attr_reader :cli

  def initialize(cli)
    @cli = cli
  end

  def display
    cli.clear_terminal

    settings_title = Rainbow('Settings').bold.bright.crimson
    CLI::UI::Frame.open(settings_title, color: :red)

    settings_prompt = Rainbow('Settings is in development...').bright.gold
    choice = CLI::UI::Prompt.ask(settings_prompt) do |handler|
      handler.option('Start Menu') { :start_menu }
      handler.option('Quit') { :quit }
    end

    CLI::UI::Frame.close nil
    cli.menu_handler.handle_signal choice
  end
end
