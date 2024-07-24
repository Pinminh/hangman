class MenuSignalHandler
  attr_reader :cli

  def initialize(cli)
    @cli = cli

    @valid_signals = %i[new_game continue load_game settings quit
                        unpause save_game start_menu]
  end

  def handle_signal(signal)
    case signal
    when :new_game then cli.main_instructor.play_game(reset: true)
    when :continue then do_continue_game
    when :load_game then cli.load_menu.display
    when :load_list then do_load_game_list
    when :unpause then cli.main_instructor.play_game
    when :save_game then cli.pause_menu.display_saving
    when :start_menu then cli.start_menu.display
    end
  end

  def do_continue_game
    game_hist = cli.hangman.game.class.pull_file_history

    return cli.main_instructor.play_game(reset: true) if game_hist.empty?

    last_save = game_hist.last
    last_game = cli.hangman.game.class.load_game last_save[:name]
    cli.hangman.game = last_game

    cli.main_instructor.play_game
  end

  def do_load_game_list
    saves_history = cli.hangman.game.class.pull_file_history
    return cli.load_menu.display_no_saves if saves_history.empty?

    cli.load_menu.display_list saves_history
  end
end
