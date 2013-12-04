require 'chorus_extractor'

module ChorusExtractor
  class Lyrics
    def initialize(blocks = [])
      @blocks = blocks
    end
  end

  class LyricsBlock
    def initialize(data, type = :lyrics)
      @data = data
      @type = lyrics
    end
  end
end
