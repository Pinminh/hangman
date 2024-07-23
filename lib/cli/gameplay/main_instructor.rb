class MainInstructor
  attr_reader :cli, :control_keys

  def initialize(cli)
    @cli = cli
    @control_keys = ["\e[A", "\e[B", "\e[C", "\e[D",
                     'w', 's', 'd', 'a'].freeze
  end

  def play_game(reset: false)
    cli.hangman.game.restart if reset == true

    cli.main_displayer.reset_cursor
    cli.main_displayer.display

    loop do
      key_value = read_key
      must_break = handle_key_value key_value

      cli.main_displayer.display

      break if must_break
    end
  end

  private

  def handle_key_value(key_value)
    if key_value == 'PAUSE'
      cli.pause_menu.display
      return true
    end

    game = cli.hangman.game
    game.guess key_value

    game.correct_guess? || game.out_of_lives?

    # cli.end_menu.display if is_end
    # is_end
  end

  def read_key
    loop do
      navi_key = ask_navigation
      is_enter = move_cursor_by_key navi_key

      cli.main_displayer.display if control_keys.include? navi_key

      break if is_enter
    end

    cli.main_displayer.value_on_cursor
  end

  def ask_navigation
    key = $stdin.getch
    key << $stdin.getch << $stdin.getch if key == "\e"

    $stdin.getch while $stdin.ready?
    key
  end

  def move_cursor_by_key(navi_key)
    case navi_key
    when "\e[A", 'w' then cli.main_displayer.move_cursor(-1, 0)
    when "\e[B", 's' then cli.main_displayer.move_cursor(1, 0)
    when "\e[C", 'd' then cli.main_displayer.move_cursor(0, 1)
    when "\e[D", 'a' then cli.main_displayer.move_cursor(0, -1)
    when "\r", ' ' then return true
    end
    false
  end
end
