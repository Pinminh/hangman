require 'cli/ui'
require 'rainbow/refinement'

# Display main menu of the game
class StartMenu
  attr_reader :instructor, :cli

  def initialize(cli)
    @cli = cli

    @author = cli.hangman.author
    @version = cli.hangman.version

    @keyboard = [('A'..'I').to_a, ('J'..'R').to_a, ('S'..'Z').to_a, ['PAUSE']]
    @cursor = { row: 0, col: 0 }

    CLI::UI::StdoutRouter.enable
  end

  def display
    cli.clear_terminal

    game_title = Rainbow('Hangman (EN)').bold.bright.crimson
    info = Rainbow("#{@version} - #{@author}").italic.silver.underline.rjust(53)
    menu_name = Rainbow('Main Menu:').bold.bright.gold

    CLI::UI::Frame.open(game_title, color: :red)
    CLI::UI::Frame.open(info, frame_style: :bracket, color: :yellow)

    choice = CLI::UI::Prompt.ask(menu_name, filter_ui: false) do |handler|
      handler.option('New Game') { :new_game }
      handler.option('Continue') { :continue }
      handler.option('Load Game') { :load_game }
      handler.option('Settings') { :settings }
      handler.option('Quit') { :quit }
    end

    CLI::UI::Frame.close nil
    CLI::UI::Frame.close nil

    cli.menu_handler.handle_signal choice
  end
end
