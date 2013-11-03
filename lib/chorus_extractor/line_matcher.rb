module ChorusExtractor
    class << self

      # A simple wrapper for Diff::LCS.diff that counts the
      def num_differences(line1, line2)
        Diff::LCS.diff(line1, line2).count
      end

      def correlation_coeff(line1, line2)
        max_line_length = [line1.length, line2.length].max

        (max_line_length - num_differences(line1, line2)).to_f / max_line_length
      end

      def compute_correlation_matrix(text)

      end
    end
end
