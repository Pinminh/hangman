module Loadable
  PSEUDO_RNG = Random.new.freeze

  SAVES_FOLDERNAME = 'saves'.freeze
  SAVES_EXTENSION = 'bin'.freeze
  DEFAULT_SAVENAME = 'default'.freeze

  META_FILENAME = '_meta'.freeze

  @@serializer = Marshal

  @@dictionary = []
  @@saves_history = []

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

    push_file_history(save_name)

    serialized_game = serialize game
    File.binwrite saves_path(save_name), serialized_game
  end

  def load_game(save_name = DEFAULT_SAVENAME)
    save_path = saves_path save_name
    raise "save file '#{save_name}' does not exist" unless File.exist? save_path

    serialized_game = File.binread save_path
    deserialize serialized_game
  end

  def pull_file_history
    return [] if File.size?(hist_path).nil?

    serialized_history = File.binread hist_path

    @@saves_history = deserialize serialized_history
  end

  private

  def saves_path(save_name = DEFAULT_SAVENAME)
    FileUtils.mkdir_p SAVES_FOLDERNAME
    "#{SAVES_FOLDERNAME}/#{save_name}.#{SAVES_EXTENSION}"
  end

  def hist_path
    FileUtils.mkdir_p SAVES_FOLDERNAME
    "#{SAVES_FOLDERNAME}/#{META_FILENAME}"
  end

  def serialize(target)
    hashed_object = {}

    target.instance_variables.each do |var_name|
      hashed_object[var_name] = target.instance_variable_get var_name
    end

    @@serializer.dump hashed_object
  end

  def deserialize(target_string)
    hashed_object = @@serializer.load target_string

    object = self.new
    object.instance_variables.each do |var_name|
      object.instance_variable_set var_name, hashed_object[var_name]
    end

    object
  end

  def push_file_history(save_name)
    @@saves_history.delete_if { |save| save[:name] == save_name }
    @@saves_history << { name: save_name, time: Time.now }

    serialized_history = serialize @@saves_history
    File.binwrite hist_path, serialized_history
  end
end
