class QuitPanel
  attr_reader :cli

  def initialize(cli)
    @cli = cli

    @colors = %i[green red yellow purple blue orange white violet magenta
                 silver tan teal gold crimson honeydew aqua aliceblue]
    @rand_colors = Random.new
  end

  def display
    cli.clear_terminal

    quit_title = Rainbow('Good Bye').bold.bright.crimson
    CLI::UI::Frame.open(quit_title, color: :red)

    message = "Thanks for playing.\nHave a nice day!"
    message.gsub!(/\w/i) { |char| Rainbow(char).bright.color(random_color) }
    CLI::UI::Printer.puts message

    CLI::UI::Frame.close nil
  end

  private

  def random_color
    random_index = @rand_colors.rand(@colors.length)
    @colors[random_index]
  end
end
