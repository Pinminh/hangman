require 'cli/ui'
require 'rainbow/refinement'

# Display load menu, saved games list and do the loading
class LoadMenu
  attr_reader :cli

  def initialize(cli)
    @cli = cli
  end

  def display
    cli.clear_terminal

    load_title = Rainbow('Load Game').bold.bright.crimson
    CLI::UI::Frame.open(load_title, color: :red)
    CLI::UI::Frame.open('', frame_style: :bracket, color: :yellow)

    safety_ask = Rainbow('Want to load game?').bold.bright.gold
    choice = CLI::UI::Prompt.ask(safety_ask, filter_ui: false) do |handler|
      handler.option('Show Game List') { :load_list }
      handler.option('Start Menu') { :start_menu }
      handler.option('Quit') { :quit }
    end

    CLI::UI::Frame.close nil
    CLI::UI::Frame.close nil

    cli.menu_handler.handle_signal choice
  end

  def display_list(saves_history)
    cli.clear_terminal

    load_title = Rainbow('Load Game').bold.bright.crimson
    CLI::UI::Frame.open(load_title, color: :red)
    CLI::UI::Frame.open('', frame_style: :bracket, color: :yellow)

    prompt = Rainbow('Choose Game to Load').bold.bright.gold
    cli.hangman.game = CLI::UI::Prompt.ask(prompt) do |handler|
      saves_history.reverse.each do |saved_hash|
        save_name = saved_hash[:name]
        info = save_info_string saved_hash

        handler.option(info) { cli.hangman.game.class.load_game save_name }
      end
    end

    CLI::UI::Frame.close nil
    CLI::UI::Frame.close nil

    display_loading
    cli.menu_handler.handle_signal :unpause
  end

  def display_no_saves
    cli.clear_terminal

    load_title = Rainbow('Load Game').bold.bright.crimson
    CLI::UI::Frame.open(load_title, color: :red)
    CLI::UI::Frame.open('', frame_style: :bracket, color: :yellow)

    prompt_error = Rainbow('There are no saved games').bold.bright.gold
    choice = CLI::UI::Prompt.ask(prompt_error, filter_ui: false) do |handler|
      handler.option('Start Menu') { :start_menu }
      handler.option('Quit') { :quit }
    end

    CLI::UI::Frame.close nil
    CLI::UI::Frame.close nil
    cli.menu_handler.handle_signal choice
  end

  private

  def save_info_string(saved_hash)
    save_name = saved_hash[:name].ljust 20, '-'
    save_time = saved_hash[:time].strftime('%H:%M:%S. %d/%m/%Y').rjust 20, '-'
    save_time = Rainbow(save_time).gray

    saved_game = cli.hangman.game.class.load_game saved_hash[:name]

    win_score = Rainbow(saved_game.num_wins).bright.green
    total_plays = Rainbow(saved_game.num_plays).bright.gold
    save_scores = "Won #{win_score}/#{total_plays}".ljust 46, '-'

    save_name + save_scores + save_time
  end

  def display_loading
    cli.clear_terminal

    load_title = Rainbow('Load Game').bold.bright.crimson
    CLI::UI::Frame.open(load_title, color: :red)
    CLI::UI::Frame.open('', frame_style: :bracket, color: :yellow)

    spin_init = Rainbow('Loading game...').bright.yellow
    spin_end = Rainbow('Complete successfully').bright.green
    CLI::UI::Spinner.spin(spin_init) do |spinner|
      sleep 1.0
      spinner.update_title(spin_end)
    end
    sleep 1.0

    CLI::UI::Frame.close nil
    CLI::UI::Frame.close nil
  end
end
