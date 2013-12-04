require 'core_ext/matrix'
require 'colorize'

module ChorusExtractor

  class << self
    def process(filename)
      lines = IO.readlines(filename).map(&:downcase)

      @correlation_map = compute_correlation_matrix(lines)
      @chorus_map      = extract_chorus_from_correlation_map(@correlation_map)
      #@annotated       = segment_chorus_map(lines, @chorus_map)

      write_image(@correlation_map, filename)
    end

    def write_image(matrix, filename)
      img = Magick::Image.new(matrix.row_size, matrix.column_size)

      matrix.each_with_index do |cc, row, col|
        img.pixel_color(row, col, "rgb(#{cc * 255}, #{cc * 255}, #{cc * 255})")
      end

      fname = /\w+\.\w+$/.match(filename).to_a.first
      img.write(fname + '_corr.bmp')
    end

    def compute_correlation_matrix(lines)
      dimension = lines.length

      Matrix.build(dimension, dimension) do |row, col|
        ChorusExtractor.correlation_coeff(lines[row].strip, lines[col].strip)
      end
    end

    def extract_chorus_from_correlation_map(correlation_matrix, threshold = 0.8, min_length = 2)
      columns        = (1...correlation_matrix.column_size)

      # For each diagonal
      mapped_columns = columns.map do |column_idx|
        diag = correlation_matrix.diagonal(column_idx)

        extract_chorus_from_diagonal(diag, column_idx, threshold, min_length)
      end.compact

      mapped_columns = mapped_columns.flatten(1)

      mapped_columns.map do |column|
        {
          coefs: column[0],
          rows:  column[1],
          cols:  column[2]
        }
      end
    end

    def extract_chorus_from_diagonal(diagonal, offset, threshold = 0.8, min_length = 2)
      groups = diagonal.each_with_index.chunk { |coeff, i|
        coeff > threshold
      }.select { |item, val|
        item && val.length >= min_length
      }.map { |item|
        item.last
      }.map(&:transpose)

      if groups.any?
        groups.each { |item|
          item << item.last.map { |sub_array| sub_array + offset }
        }
      end
    end

    def segment_chorus_map(lines, chorus_map)
      annotated_lines = lines.each_with_index.map do |line, idx|
        {
          score:       0,
          line_number: idx,
          groups:      [],
          lyrics:      line
        }
      end

      # For each potential chorus block that's found:
      chorus_map.each_with_index do |chorus_data, chorus_idx|
        # Get the coeffcients, rows, and columns for each:
        chorus_data.each_with_index do |match, match_idx|
          coefs = match[0]
          rows  = match[1]
          cols  = match[2]

          rows.each_with_index do |row, idx|
            col = cols[idx]

            line1 = annotated_lines[row]
            line2 = annotated_lines[col]

            line1[:score] += 1
            line2[:score] += 1

            line1[:groups] << chorus_idx
            line2[:groups] << chorus_idx
          end
        end
      end

      unique_groups = annotated_lines.map { |line| line[:groups] }.uniq.compact

      return annotated_lines
    end

    def lines_by_group(annotated_lines, group)
      annotated_lines.select { |line| line[:group] == group }
    end

    private

    def compute_average(array)
      sum = array.inject(:+)
      sum.to_f / array.length
    end
  end
end
