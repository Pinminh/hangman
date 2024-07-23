require_relative 'game_operator'
require_relative '../cli/game_cli'

class Hangman
  VERSION = '0.1.0'.freeze
  AUTHOR = 'Pmin'.freeze

  attr_reader :version, :author, :game, :cli

  def initialize
    @version = VERSION
    @author = AUTHOR

    @game = GameOperator.new
    @cli = GameCLI.new self
  end

  def run
    cli.start_menu.display
  end
end
