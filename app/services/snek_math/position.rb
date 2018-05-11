module SnekMath
  class Position

    attr_reader :snek, :position

    # @param snek [Snek]
    # @param position [Array]
    def initialize(snek, position)
      @snek = snek
      @position = position
    end

    # Move snek to direction
    # @param direction [String] Direction: N, E, S, W
    # @param grow [Boolean] If true, snek grows by one cell. Otherwise moves.
    # @throws Exception if Snek tries to move to itself
    def move(direction, grow = false)

      # Move head and body
      case direction
      when 'N'
        new_position = { x: position[0][:x], y: (position[0][:y] - 1) }
      when 'S'
        new_position = { x: position[0][:x], y: (position[0][:y] + 1) }
      when 'E'
        new_position = { x: (position[0][:x] + 1), y: position[0][:y] }
      when 'W'
        new_position = { x: (position[0][:x] - 1), y: position[0][:y] }
      else
        raise Exception, 'Incorrect direction for move'
      end

      # Prevent snek to move to itself. But snek can move to it's tail if it is not grows
      (0..(position.length - 2)).each do |i|
        if position[i][:x] == new_position[:x] && position[i][:y] == new_position[:y]
          raise Exception, 'Snek tries to go to itself'
        end
      end
      if !grow && position.last[:x] == new_position[:x] && position.last[:y] == new_position[:y]
        raise Exception, 'Snek tries to go to its tail'
      end

      # Add new position of the head
      @position.unshift new_position

      # If not grow, pull tail forward (otherwise leave it at place, because of growth)
      unless grow
        @position.pop
      end

      nil
    end

    # Returns head coordinates
    # @returns Hash
    def get_head_coords
      position.first
    end

    # @return String
    # @throws Exception
    def get_current_direction
      if position[0][:x] == position[1][:x] && position[0][:y] < position[1][:y]
        return 'N'
      elsif position[0][:x] == position[1][:x] && position[0][:y] > position[1][:y]
        return 'S'
      elsif position[0][:x] > position[1][:x] && position[0][:y] == position[1][:y]
        return 'E'
      elsif position[0][:x] < position[1][:x] && position[0][:y] == position[1][:y]
        return 'W'
      else
        raise Exception, "Incorrect snek position direction: #{position}"
      end
    end

    # Put snek on SnekMath::Matrix arena.
    # Changes matrix
    # @param matrix [SnekMath::Matrix]
    def draw_on(matrix)
      @position.each_with_index do |coords, i|
        if i.zero?
          matrix.set(coords[:x], coords[:y], "head-#{@snek.id}")
        elsif i == (position.length - 1)
          matrix.set(coords[:x], coords[:y], "tail-#{@snek.id}")
        else
          matrix.set(coords[:x], coords[:y], "body-#{@snek.id}")
        end
      end
    end

    # @return Fixnum
    def snek_length
      position.length
    end

  end
end