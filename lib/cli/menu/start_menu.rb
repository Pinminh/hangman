require 'cli/ui'
require 'rainbow/refinement'

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

    handle_options choice
  end

  private

  def handle_options(choice)
    case choice
    when :new_game then cli.main_instructor.play_game
    end
  end
end
