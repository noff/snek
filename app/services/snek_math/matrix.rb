module SnekMath
  class Matrix

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


    # TODO get column
    # TODO get row
    # TODO get submatrix
    def [](x,y)

      # Validations
      raise(ArgumentError, 'X less than 0') if !x.nil? && x < 0
      raise(ArgumentError, 'Y less than 0') if !y.nil? && y < 0
      raise(ArgumentError, 'X more than matrix size') if !x.nil? && x >= self.width
      raise(ArgumentError, 'Y more than matrix size') if !y.nil? && y >= self.height
      # X and Y not set, it's bad
      if x.nil? && y.nil?
        raise(ArgumentError, 'X and Y are not set') if x.nil? && y.nil?
      # Y is not set, fetch column
      elsif x.nil? && !y.nil?

      # X is not set, fetch row
      elsif !x.nil? && y.nil?


      # Get a value from the specific cell
      else
        @area[y][x]
      end
    end

    # TODO fill row
    # TODO fill column
    def []=(x,y,value)

      # Validations
      raise(ArgumentError, 'X less than 0') if !x.nil? && x < 0
      raise(ArgumentError, 'Y less than 0') if !y.nil? && y < 0
      raise(ArgumentError, 'X more than matrix size') if !x.nil? && x >= self.width
      raise(ArgumentError, 'Y more than matrix size') if !y.nil? && y >= self.height

      # X and Y not set, fill all cels
      if x.nil? && y.nil?
        @area.each_with_index do |row, y_index|
          row.each_with_index do |cell,x_index|
            @area[y_index][x_index] = value
          end
        end
      # Y is not set, fill column
      elsif x.nil? && !y.nil?

      # X is not set, fill row
      elsif !x.nil? && y.nil?


      # Set value to the specific cell
      else
        @area[y][x] = value
      end

      nil

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
