require_relative 'game_operator'
require_relative '../cli/game_cli'

# Wrapper for everything related to hangman game
class Hangman
  VERSION = '0.1.0'.freeze
  AUTHOR = 'Pmin'.freeze

  attr_reader :version, :author, :cli
  attr_accessor :game

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
