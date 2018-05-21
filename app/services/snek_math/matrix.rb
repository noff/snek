module SnekMath
  class Matrix

    attr_reader :area

    class << self

      def from_json(json)
        m = self::new(json.first.length, json.length, nil)
        json.each_with_index do |row, y|
          row.each_with_index do |cell, x|
            m.set(x, y, cell)
          end
        end
        m
      end

    end

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
      new_matrix = SnekMath::Matrix.new(x2 - x1 + 1, y2 - y1 + 1, fill)
      new_matrix.area.each_with_index do |row, y|
        row.each_with_index do |_, x|
          if (x1 + x) >= 0 && (x1 + x) < width && (y1 + y) >= 0 && (y1 + y) < height
            new_matrix.set(x, y, get(x1 + x, y1 + y))
          end
        end
      end
      new_matrix
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

    # Rotate matrix
    # @param degree [Fixnum] Degree: 90, 180, 270
    # TODO: rspec
    def rotate!(degree)
      degree = 270 if degree == -90
      case degree
      when 0
        # Do nothing
      when 90
        new_area = SnekMath::Matrix.new(height, width, nil)
        @area.each_with_index do |row, y|
          row.each_with_index do |cell, x|
            new_area.set(new_area.width - y - 1, x, cell)
          end
        end
        @area = new_area.area
      when 180
        new_area = SnekMath::Matrix.new(width, height, nil)
        @area.each_with_index do |row, y|
          row.each_with_index do |cell, x|
            new_area.set(width - x - 1, height - y - 1, cell)
          end
        end
        @area = new_area.area
      when 270
        new_area = SnekMath::Matrix.new(height, width, nil)
        @area.each_with_index do |row, y|
          row.each_with_index do |cell, x|
            new_area.set(y, new_area.height - x - 1, cell)
          end
        end
        @area = new_area.area
      else
        raise ArgumentError, 'Wrong degree. Only 90, 180 and 270 supported'
      end
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

    # @return String
    def to_str
      @area.map { |row| row.join("\t") }.join("\n")
    end

    # @return String
    def to_json
      @area.to_json
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
