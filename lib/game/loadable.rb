module Loadable
  PSEUDO_RNG = Random.new.freeze

  SAVES_FOLDERNAME = 'saves'.freeze
  SAVES_EXTENSION = 'bin'.freeze
  DEFAULT_SAVENAME = 'default'.freeze

  @@serializer = Marshal

  @@dictionary = []

  def load_dictionary(path = 'resource/google-10000-english-no-swears.txt')
    @@dictionary = File.readlines(path, chomp: true)
  end

  def load_random_word
    load_dictionary unless !@@dictionary.nil? && @@dictionary.length.positive?

    random_index = PSEUDO_RNG.rand @@dictionary.length
    @@dictionary[random_index]
  end

  def serializer=(serializer_class)
    @@serializer = serializer_class
  end

  def save_game(game, save_name = DEFAULT_SAVENAME)
    raise 'passed object is not game operator' unless game.is_a? self

    serialized_game = serialize game
    File.binwrite saves_path(save_name), serialized_game
  end

  def load_game(save_name = DEFAULT_SAVENAME)
    save_path = saves_path save_name
    raise "save file '#{save_name}' does not exist" unless File.exist? save_path

    serialized_game = File.binread save_path
    deserialize serialized_game
  end

  def saves_path(save = DEFAULT_SAVENAME)
    FileUtils.mkdir SAVES_FOLDERNAME unless Dir.exist? SAVES_FOLDERNAME
    "#{SAVES_FOLDERNAME}/#{save}.#{SAVES_EXTENSION}"
  end

  private

  def serialize(game)
    hashed_object = {}

    game.instance_variables.each do |var_name|
      hashed_object[var_name] = game.instance_variable_get var_name
    end

    @@serializer.dump hashed_object
  end

  def deserialize(game_string)
    hashed_object = @@serializer.load game_string

    game = self.new
    game.instance_variables.each do |var_name|
      game.instance_variable_set var_name, hashed_object[var_name]
    end

    game
  end
end
