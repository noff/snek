module SnekMath

  class Pattern

    attr_reader :matrix

    # @param pattern [Array] 2-dimensional array from snek rules
    def initialize(pattern)
      @source_matrix = SnekMath::Matrix.new pattern[0].length, pattern.length, nil
      pattern.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          @source_matrix.set(x, y, cell)
        end
      end
      # This matrix will be used for rotated copy
      @matrix = @source_matrix.dup
    end

    # Check if the pattern is empty
    # @return Boolean
    def empty?
      matrix.area.each do |row|
        row.each do |cell|
          return false if cell[0] != 'my_head' && cell[0] != 'default'
        end
      end
      true
    end

    # @return Hash
    # @throws Exception If my_head is not found in the pattern
    def get_my_head_coords
      @matrix.area.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          if cell[0] == 'my_head'
            return {x: x, y: y}
          end
        end
      end
      raise Exception, 'My head not found in the pattern'
    end

    # Reset rotated matrix
    def reset!
      @matrix = @source_matrix.dup
    end

    # Rotate matrix
    # @param direction [String] N, W, S, E. Doesn't do anything for N
    def rotate!(direction)
      reset!
      if direction == 'N'
        # Do nothing
      elsif direction == 'S'
        @matrix.rotate!(180)
      elsif direction == 'W'
        @matrix.rotate!(270)
      elsif direction == 'E'
        @matrix.rotate!(90)
      end
      nil
    end

  end

end
