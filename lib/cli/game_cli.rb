require_relative 'cli_displayer'
require_relative 'cli_instructor'

class GameCLI
  attr_reader :hangman, :displayer, :instructor

  def initialize(hangman)
    @hangman = hangman
    @displayer = CliDisplayer.new self
    @instructor = CliInstructor.new self
  end
end
