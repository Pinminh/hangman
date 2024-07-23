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
    when :unpause then cli.main_instructor.play_game
    when :save_game then cli.pause_menu.display_saving
    when :start_menu then cli.start_menu.display
    end
  end
end
