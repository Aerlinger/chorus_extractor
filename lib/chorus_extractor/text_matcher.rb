require 'core_ext/matrix'
require 'colorize'

module ChorusExtractor
  class << self
    def process(filename)
      lines = IO.readlines(filename).map(&:downcase)

      correlation_map = compute_correlation_matrix(lines)
      chorus_map      = extract_chorus_from_correlation_map(correlation_map)
      annotated       = annotate_lines_from_chorus_map(lines, chorus_map)

      write_image(correlation_map, filename)

      return annotated
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
      end

      mapped_columns.select(&:any?)
    end

    def extract_chorus_from_diagonal(diagonal, offset, threshold = 0.8, min_length = 2)
      groups = diagonal.each_with_index.chunk { |coeff, i|
        coeff > threshold
      }.select { |item, val|
        item && val.length >= min_length
      }.map { |item|
        item.last
      }.map(&:transpose)

      groups.each { |item|
        item << item.last.map { |sub_array| sub_array + offset }
      }
    end

    def annotate_lines_from_chorus_map(lines, chorus_map)
      chorus_map.each_with_index do |chorus_data, chorus_idx|
        prefix = ""

        chorus_data.each_with_index do |match, match_idx|
          coefs = match[0]
          rows  = match[1]
          cols  = match[2]

          #color = String.colors[chorus_idx + 1]
          #color_background = String.colors[0]

          rows.each_with_index do |row, idx|
            col  = cols[idx]
            coef = coefs[idx]

            color = String.colors[chorus_idx]
            color_background = String.colors[0]

            lines[row] = lines[row].colorize(color: color, background: color_background)
            lines[col] = lines[col].colorize(color: color, background: color_background)
          end
        end
      end

      chorus_map.each_with_index do |chorus_data, chorus_idx|
        prefix = ""

        chorus_data.each_with_index do |match, match_idx|
          coefs = match[0]
          rows  = match[1]
          cols  = match[2]

          rows.each_with_index do |row, idx|
            col  = cols[idx]
            coef = coefs[idx]

            lines[row].prepend(' ')
            lines[col].prepend(' ')
          end
        end
      end

      lines.each_with_index { |line, idx| line.prepend(" #{(idx + 1).to_s + (idx < 9 ? " " : "")} | ").bold }

      return lines
    end
  end
end
