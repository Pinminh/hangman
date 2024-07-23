class CliInstructor
  def initialize(cli)
    @cli = cli
  end

  def handle_start_menu(signal)
    case signal
    when :new_game then do_new_game
    when :continue
    when :load_game
    when :settings
    when :quit
    end
  end

  private

  def do_new_game
    loop do
      @cli.displayer.display_gameplay

      arrow_key = ask_navigation
      case arrow_key
      when "\e[A" then @cli.displayer.move_cursor(-1, 0)
      when "\e[B" then @cli.displayer.move_cursor(1, 0)
      when "\e[C" then @cli.displayer.move_cursor(0, 1)
      when "\e[D" then @cli.displayer.move_cursor(0, -1)
      end
    end
  end

  def ask_navigation
    key = ''

    $stdin.raw do
      key = $stdin.getch
      key += $stdin.getch + $stdin.getch if key == "\e"
    end

    key
  end
end
