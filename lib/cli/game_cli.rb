require_relative 'gameplay/main_displayer'
require_relative 'gameplay/main_instructor'

require_relative 'menu/start_menu'

class GameCLI
  attr_reader :hangman, :main_displayer, :main_instructor, :start_menu

  def initialize(hangman)
    @hangman = hangman

    @main_displayer = MainDisplayer.new self
    @main_instructor = MainInstructor.new self

    @start_menu = StartMenu.new self
  end
end
