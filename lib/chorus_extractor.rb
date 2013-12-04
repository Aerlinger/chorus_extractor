require "chorus_extractor/version"
require "matrix"
require "rmagick"
require "diff-lcs"
require "diff/lcs/string"

require "chorus_extractor/line_matcher"
require "chorus_extractor/text_matcher"

module ChorusExtractor
  class Main
    def initialize(filename)
      @lines = IO.readlines(filename).map(&:downcase)

      @correlation_map = ChorusExtractor.compute_correlation_matrix(@lines)
      @chorus_map      = ChorusExtractor.extract_chorus_from_correlation_map(@correlation_map)
    end

    def find_largest_chorus_block
      @largest_chorus_block = @chorus_map.max_by { |chorus_block| chorus_block[:coefs].length }
    end

    def process_line_data

    end

    def show_lines
      @largest_chorus_block ||= find_largest_chorus_block

      @line_data = @lines.each_with_index.map do |line, idx|
        {
          score:       0,
          type:        :verse,
          line_number: idx,
          lyrics:      line
        }
      end

      rows = @largest_chorus_block[:rows]
      cols = @largest_chorus_block[:cols]

      smallest_idx = (rows + cols).min
      largest_idx = (rows + cols).max

      rows.each { |row| @line_data[row][:type] = :chorus }
      cols.each { |col| @line_data[col][:type] = :chorus }

      @lines.values_at(smallest_idx..largest_idx)
    end

    def text_from_line_data
      show_lines

      @chunked = @line_data.chunk { |line|
        line[:type] == :chorus
      }

      processed_output = ""

      @chunked.each do |is_chorus, lyrics_group|
        processed_output << (is_chorus ? "[:chorus:]\n" : "[:verse:]\n")
        lyrics_group.each do |lyrics_block|
          processed_output << lyrics_block[:lyrics].capitalize
        end

        processed_output << "\n"
      end

      puts processed_output
      return processed_output
    end
  end
end
