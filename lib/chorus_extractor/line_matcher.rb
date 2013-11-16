module ChorusExtractor
  class << self
    # Counts the number of ordered similarities between line1 and line2
    def num_similarities(line1, line2)
      Diff::LCS::Internals.lcs(line1, line2).compact.length
    end

    # Counts the number of changes necessary to convert line1 into line2
    def num_deltas(line1, line2)
      Array(Diff::LCS.diff(line1, line2))[0].length
    end

    # Returns a two element array of line1 and line2 sorted by string length
    def shortest_longest(line1, line2)
      [line1, line2].sort { |n| n.length }
    end

    # Returns a float between 0-1 indicating number of changes required to turn line1 into line2
    # divided by the total possible changes required to change line1 into line2
    def delta_coefficient(line1, line2)
      shorter_line, longer_line = shortest_longest(line1, line2)
      return 0 if longer_line.length.zero?

      changes_count = num_deltas(shorter_line, longer_line)
      total_possible_changes_count = shorter_line.length + longer_line.length

      (total_possible_changes_count - changes_count.to_f)/total_possible_changes_count
    end

    # Returns a coefficient (float) indicating the number of ordered similarities between the two strings
    # divided by the length of the longer string
    def overlap_coefficient(line1, line2)
      shorter_line, longer_line = shortest_longest(line1, line2)
      return 0 if longer_line.length.zero?

      similar_letters_count = num_similarities(shorter_line, longer_line)

      similar_letters_count.to_f/longer_line.length
    end

    def correlation_coeff(line1, line2)
      if ENV['MATCH_ALGORITHM'] = 'overlap'
        overlap_coefficient(line1, line2)
      else
        #overlap_coefficient(line1, line2)
        delta_coefficient(line1, line2)
      end
    end
  end
end
