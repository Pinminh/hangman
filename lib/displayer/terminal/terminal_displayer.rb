require 'cli/ui'
require_relative '../../game/hangman'

class TerminalDisplayer
  def initialize
    CLI::UI::StdoutRouter.enable
  end

  def start_menu
    CLI::UI::Frame.open(CLI::UI.fmt('{{bold:English Hangman}}')) do
      header = "#{Hangman::VERSION} - #{Hangman::AUTHOR}".rjust(32)
      puts CLI::UI.fmt "{{bold:#{header}}}"

      choices = {
        new_game: 'New Game',
        continue: 'Continue',
        load_game: 'Load Game',
        settings: 'Settings',
        quit: 'Quit'
      }

      choice = CLI::UI::Prompt.ask('Main Menu:', filter_ui: false) do |handler|
        choices.each { |op_code, option| handler.option(option) { op_code } }
      end

      choice
    end
  end
end

t = TerminalDisplayer.new
t.start_menu
