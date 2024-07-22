module Loadable
  PSEUDO_RNG = Random.new.freeze

  @@dictionary = []

  def load_dictionary(path = 'resource/google-10000-english-no-swears.txt')
    @@dictionary = File.readlines(path, chomp: true)
  end

  def load_random_word
    load_dictionary unless !@@dictionary.nil? && @@dictionary.length.positive?

    random_index = PSEUDO_RNG.rand(@@dictionary.length)
    @@dictionary[random_index]
  end
end
