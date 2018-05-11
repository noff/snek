module SnekMath

  class Pattern

    attr_reader :matrix

    # @param pattern [Array] 2-dimensional array from snek rules
    def initialize(pattern)
      @matrix = SnekMath::Matrix.new pattern[0].length, pattern.length, nil
      pattern.each_with_index do |row, y|
        row.each_with_index do |cell, x|
          @matrix.set(x, y, cell)
        end
      end
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

  end

end
