require 'matrix'

class Matrix
  # Returns a diagonal offset from the main diagonal by n
  #
  # The returned array will have a length of the number of rows of this matrix minus the offset
  def diagonal(n, &block)
    count = row_size - n

    count.times.map do |idx|
      if block_given?
        yield self[idx + n, idx]
      else
        self[idx + n, idx]
      end
    end
  end

  def diagonals
    row_size.times do |idx|
      yield diagonal(idx)
    end
  end
end
