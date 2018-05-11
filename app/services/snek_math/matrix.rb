module SnekMath
  class Matrix

    attr_reader :area

    # Create matrix
    # @param [Fixnum] width
    # @param [Fixnum] height
    # @param [String] fill
    # @return SnekMath::Matrix
    def initialize(width, height, fill = 'empty')
      @area = Array.new(height) { Array.new(width, fill) }
    end

    # Get value in the specific cell
    # @param [Fixnum] x
    # @param [Fixnum] y
    # @return String
    def get(x, y)
      validate_x!(x)
      validate_y!(y)
      @area[y][x]
    end

    # Set value to the specific cell
    # @param [Fixnum] x
    # @param [Fixnum] y
    # @param [String] value
    # @return String
    def set(x, y, value)
      validate_x!(x)
      validate_y!(y)
      @area[y][x] = value
    end

    # Return column
    # @param [Fixnum] x
    # @return Array
    def get_column(x)
      validate_x!(x)
      @area.map { |row| row[x] }
    end

    # Fill column with value
    # @param [Fixnum] x
    # @param [String] value
    # @return String
    def set_column(x, value)
      validate_x!(x)
      @area.each { |row| row[x] = value }
      value
    end

    # Return row
    # @param [Fixnum] y
    # @return Array
    def get_row(y)
      validate_y!(y)
      @area[y]
    end

    # Fill row with value
    # @param [Fixnum] y
    # @param [String] value
    # @return String
    def set_row(y, value)
      validate_y!(y)
      (0..(self.width - 1)).each { |x| @area[y][x] = value }
      value
    end

    # Fill selected area
    # @param [Fixnum] x1
    # @param [Fixnum] y1
    # @param [Fixnum] x2
    # @param [Fixnum] y2
    # @param [String] value
    # @return String
    def set_rect(x1, y1, x2, y2, value)
      validate_x!(x1)
      validate_x!(x2)
      validate_y!(y1)
      validate_y!(y2)

      # Sort ascending (will be the same area)
      (x2, x1 = x1, x2) if x1 > x2
      (y2, y1 = y1, y2) if y1 > y2

      # Fill
      (y1..y2).each do |y|
        (x1..x2).each do |x|
          @area[y][x] = value
        end
      end
      value
    end

    # Get submatrix
    # @param [Fixnum] x1
    # @param [Fixnum] y1
    # @param [Fixnum] x2
    # @param [Fixnum] y2
    # @param [String] fill Which value to use to fill cells if selected area is outside of the matrix
    # @return SnekMath::Matrix
    def get_rect(x1, y1, x2, y2, fill = nil)
      raise NotImplementedError
    end

    # TODO
    def add_column
      raise NotImplementedError
    end

    # TODO
    def delete_column
      raise NotImplementedError
    end

    # TODO
    def add_row
      raise NotImplementedError
    end

    # TODO
    def delete_row
      raise NotImplementedError
    end


    # Get matrix width
    # @return Integer
    def width
      @area[0].length
    end

    # Get matrix height
    # @return Integer
    def height
      @area.length
    end

    # Debug matrix
    def print
      @area.each do |row|
        puts row.join("\t")
      end
      nil
    end

    private

    # Validate X value
    # @throws ArgumentError
    def validate_x!(value)
      raise(ArgumentError, 'X is not integer') if !value.is_a?(Fixnum)
      raise(ArgumentError, 'X is less than 0') if value < 0
      raise(ArgumentError, 'X is more than matrix width') if value >= self.width
    end

    # Validate Y value
    # @throws ArgumentError
    def validate_y!(value)
      raise(ArgumentError, 'Y is not integer') if !value.is_a?(Fixnum)
      raise(ArgumentError, 'Y is less than 0') if value < 0
      raise(ArgumentError, 'Y is more than matrix height') if value >= self.height
    end

  end
end
