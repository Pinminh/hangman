class MainInstructor
  attr_reader :cli, :control_keys

  def initialize(cli)
    @cli = cli
    @control_keys = ["\e[A", "\e[B", "\e[C", "\e[D", "\r",
                     'w', 's', 'd', 'a', ' '].freeze
  end

  def play_game
    cli.main_displayer.display

    loop do
      navi_key = ask_navigation

      is_paused = take_action_by_key navi_key

      cli.main_displayer.display if control_keys.include? navi_key

      break if is_paused
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

  def take_action_by_key(navi_key)
    state = false
    cursor_value = cli.main_displayer.value_on_cursor

    case navi_key
    when "\e[A", 'w' then cli.main_displayer.move_cursor(-1, 0)
    when "\e[B", 's' then cli.main_displayer.move_cursor(1, 0)
    when "\e[C", 'd' then cli.main_displayer.move_cursor(0, 1)
    when "\e[D", 'a' then cli.main_displayer.move_cursor(0, -1)
    when "\r", ' ' then state = handle_key_value cursor_value
    end

    state
  end

  def handle_key_value(key_value)
    return true if key_value == 'PAUSE'

    game = cli.hangman.game
    game.guess key_value
    return true if game.correct_guess? || game.out_of_lives?

    false
  end
end
