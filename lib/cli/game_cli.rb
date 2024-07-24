require_relative 'gameplay/main_displayer'
require_relative 'gameplay/main_instructor'

require_relative 'menu/start_menu'
require_relative 'menu/load_menu'
require_relative 'menu/pause_menu'

require_relative 'menu/menu_signal_handler'

class GameCLI
  attr_reader :hangman, :main_displayer, :main_instructor,
              :start_menu, :pause_menu, :load_menu,
              :menu_handler

  def initialize(hangman)
    @hangman = hangman

    @main_displayer = MainDisplayer.new self
    @main_instructor = MainInstructor.new self

    @start_menu = StartMenu.new self
    @load_menu = LoadMenu.new self
    @pause_menu = PauseMenu.new self

    @menu_handler = MenuSignalHandler.new self
  end

  def clear_terminal
    system('cls') || system('clear')
  end
end
