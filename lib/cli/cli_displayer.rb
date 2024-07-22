require 'cli/ui'
require 'rainbow/refinement'

class CliDisplayer
  def initialize
    CLI::UI::StdoutRouter.enable
  end

  def display_start_menu
    game_title = Rainbow('Hangman (EN)').gold.bright
    info = Rainbow("#{Hangman::VERSION} - #{Hangman::AUTHOR}").white.italic

    CLI::UI::Frame.open("{{bold:#{game_title}}}") do
      CLI :UI::Frame.open("{{underline:#{info}}}", frame_style: :bracket) do
        choice = CLI::UI::Prompt.ask('', filter_ui: false) do |handler|
          handler.option('New Game') { :new_game }
          handler.option('Continue') { :continue }
          handler.option('Load Game') { :load_game }
          handler.option('Settings') { :settings }
          handler.option('Quit') { :quit }
        end

        choice
      end
    end
  end
end
