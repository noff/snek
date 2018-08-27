module SnekMath
  class Position

    # Local error for exit from nested loops
    class NotMatchedPattern < StandardError; end;

    attr_reader :snek, :position

    # @param snek [Snek]
    # @param position [Array]
    def initialize(snek, position)
      @snek = snek
      @position = position
    end

    # Get next possible move direction (N, E, S, W)
    # @param arena [SnekMath::Matrix]
    # @return Array
    def get_next_move(arena)

      Rails.logger.debug "get_next_move: Snek #{@snek.id}"

      # Snek head coordinates on arena
      current_head_coordinates = get_head_coords

      Rails.logger.debug "get_next_move: Head coords: X: #{current_head_coordinates[:x]}, Y: #{current_head_coordinates[:y]}, D: #{current_head_coordinates[:direction]}"

      # Cycle snek's patterns and find matched pattern if possible
      # Remove duplicate rules
      @snek.rules.uniq.each_with_index do |pattern, pattern_index|

        # Snek's rules pattern
        pattern_matrix = SnekMath::Pattern.new(pattern)

        # Skip empty patterns
        next if pattern_matrix.empty?

        Rails.logger.debug "=== Pattern ##{pattern_index} Matrix ==="
        Rails.logger.debug pattern_matrix.matrix.to_str
        Rails.logger.debug '=== /Pattern Matrix ==='

        # Also mirror pattern
        [false, true].each do |do_mirror|

          # Possible directions for current head direction
          current_possible_directions = possible_directions

          while test_direction = current_possible_directions.shift

            Rails.logger.debug "get_next_move: Rotate matrix ##{pattern_index} to #{test_direction}. Flip: #{do_mirror}"

            # Rotate pattern to snek's head direction
            pattern_matrix.reset!
            pattern_matrix.flip_horizontal! if do_mirror
            pattern_matrix.rotate! test_direction

            Rails.logger.debug "=== Rotated matrix ==="
            Rails.logger.debug pattern_matrix.matrix.to_str
            Rails.logger.debug "=== /Rotated matrix ==="

            # Get observable area coords
            snek_head_coords_in_pattern = pattern_matrix.get_my_head_coords
            x1 = current_head_coordinates[:x] - snek_head_coords_in_pattern[:x]
            y1 = current_head_coordinates[:y] - snek_head_coords_in_pattern[:y]
            x2 = x1 + pattern_matrix.matrix.width - 1
            y2 = y1 + pattern_matrix.matrix.height - 1

            # Cut area around snek's head
            observable_area = arena.get_rect(x1, y1, x2, y2, 'wall')

            Rails.logger.debug "=== Observable area ==="
            Rails.logger.debug observable_area.to_str
            Rails.logger.debug "=== /Observable area ==="

            # Check pattern matches to the current situation
            # How it works:
            # We check cell is (not) equal to AND or NOT pattern cell. If not - raise error and rotate pattern (or move to the next pattern)
            # We check OR cell has at least one match for each group of same cells. If AND or NOT matching didn't raise error, we check OR matching.
            # If OR matching failed, rotate pattern or go to the next pattern
            optional_matches = {}
            begin
              observable_area.area.each_with_index do |row, y|
                row.each_with_index do |cell, x|

                  # Get cell
                  pattern_cell = pattern_matrix.matrix.get(x, y)

                  # Save all optional groups to this hash. Later all values must be true
                  optional_matches[pattern_cell[0]] = false if pattern_cell[1] == 'or' and !optional_matches.key?(pattern_cell[0])

                  # Skip if pattern_cell is default
                  next if pattern_cell[0] == 'default'

                  case cell
                  when 'empty', 'wall'
                    Rails.logger.debug "get_next_move: check cell (#{x}, #{y}). Cell: #{cell}. Pattern cell: #{pattern_cell.inspect}"
                    case pattern_cell[1]
                    when 'or'
                      optional_matches[pattern_cell[0]] = true if pattern_cell[0] == cell
                    when 'not'
                      raise NotMatchedPattern if pattern_cell[0] == cell
                    when 'and'
                      raise NotMatchedPattern unless pattern_cell[0] == cell
                    else
                      Rails.logger.debug "get_next_move: Incorrect logic: #{pattern_cell[1]}"
                      raise Exception, "Incorrect logic in empty or wall: <#{pattern_cell[1].inspect}>. Pattern cell: <#{pattern_cell.inspect}>. Pattern: <#{pattern_matrix.matrix.to_str}>. Snek: <#{@snek.id}>"
                    end
                  else
                    # Sneks bodies, heads and tails
                    parts = cell.split('-')
                    raise Exception, "Not supported cell value: #{cell}" unless parts.length == 2
                    raise Exception, "Not supported cell value: #{cell}" unless %w[head body tail].include?(parts[0])
                    if parts[1].to_i == @snek.id
                      # My parts
                      Rails.logger.debug "get_next_move: check cell (#{x}, #{y}). Cell: #{parts.inspect}. Pattern cell: #{pattern_cell.inspect}"
                      case pattern_cell[1]
                      when 'or'
                        optional_matches[pattern_cell[0]] = true if pattern_cell[0] == "my_#{parts[0]}"
                      when 'not'
                        raise NotMatchedPattern if pattern_cell[0] == "my_#{parts[0]}"
                      when 'and'
                        raise NotMatchedPattern unless pattern_cell[0] == "my_#{parts[0]}"
                      else
                        raise Exception, "Incorrect logic in my parts: <#{pattern_cell[1].inspect}>. Pattern cell: <#{pattern_cell.inspect}>. Pattern: <#{pattern_matrix.matrix.to_str}>. Snek: <#{@snek.id}>"
                      end
                    else
                      # Enemy parts
                      Rails.logger.debug "get_next_move: check cell (#{x}, #{y}). Cell: #{parts.inspect}. Pattern cell: #{pattern_cell.inspect}"
                      case pattern_cell[1]
                      when 'or'
                        optional_matches[pattern_cell[0]] = true if pattern_cell[0] == "enemy_#{parts[0]}"
                      when 'not'
                        raise NotMatchedPattern if pattern_cell[0] == "enemy_#{parts[0]}"
                      when 'and'
                        raise NotMatchedPattern unless pattern_cell[0] == "enemy_#{parts[0]}"
                      else
                        raise Exception, "Incorrect logic in enemy parts: <#{pattern_cell[1].inspect}>. Pattern cell: <#{pattern_cell.inspect}>. Pattern: <#{pattern_matrix.matrix.to_str}>. Snek: <#{@snek.id}>"
                      end
                    end
                  end
                end
              end
            rescue NotMatchedPattern
              Rails.logger.debug 'get_next_move: cell is not match'
              # Pattern in this direction doesn't match, go to the next direction
              next
            end

            Rails.logger.debug "get_next_move: Pattern ##{pattern_index} to direction #{test_direction}. Optional cells: #{optional_matches.inspect}"

            # If pattern matched, return it
            if optional_matches.empty? || optional_matches.values.uniq == [true]
              Rails.logger.info "get_next_move: Matched pattern ##{pattern_index} of snek #{@snek.id} to direction #{test_direction}"
              return [test_direction, pattern_index]
            end

          end

        end

      end

      # No steps found, return random direction
      [possible_directions.sample, nil]
    end


    # Tries to get any free direction
    # @return String or nil
    def get_random_next_move(arena)
      head = get_head_coords
      moves = []
      # N
      cell = arena.get(head[:x], head[:y] - 1)
      moves << 'N' if cell == 'empty' || cell[0..3] == 'tail'
      # S
      cell = arena.get(head[:x], head[:y] + 1)
      moves << 'S' if cell == 'empty' || cell[0..3] == 'tail'
      # E
      cell = arena.get(head[:x] + 1, head[:y])
      moves << 'E' if cell == 'empty' || cell[0..3] == 'tail'
      # W
      cell = arena.get(head[:x] - 1, head[:y])
      moves << 'W' if cell == 'empty' || cell[0..3] == 'tail'

      # Return any direction or nil
      moves.sample
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

      # Prevent snek to move to itself. But snek can move to it's tail if it isn't grow AND snek longer than 2 cells
      (0..(position.length - 2)).each do |i|
        if position[i][:x] == new_position[:x] && position[i][:y] == new_position[:y]
          raise Exception, 'Snek tries to go to itself'
        end
      end

      # Can't eat self tail
      if grow && position.last[:x] == new_position[:x] && position.last[:y] == new_position[:y]
        raise Exception, 'Snek tries to go to its tail'
      end

      # Add new position of the head
      @position.unshift new_position

      # If not grow, pull tail forward (otherwise leave it at place, because of growth)
      unless grow
        @position.pop
      end

      Rails.logger.info "Move: snek ##{@snek.id}. Length: #{@position.length}. Grow: #{grow}"

      nil
    end

    # Returns head coordinates: X, Y and direction
    # @returns Hash
    def get_head_coords
      {
          x: position.first[:x],
          y: position.first[:y],
          direction: get_current_direction
      }
    end


    # Return destination coords for move
    # @param direction [String]
    # @return Fixnum,Fixnum
    def get_next_coords(direction)
      x, y = get_head_coords[:x], get_head_coords[:y]
      case direction
      when 'S'
        y += 1
      when 'N'
        y -= 1
      when 'E'
        x += 1
      when 'W'
        x -= 1
      end
      return x, y
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

    # Returns an array of possible directions: all except opposite to the current
    # @return String[]
    def possible_directions
      case get_current_direction
        when 'N'
        %w[N E W]
      when 'E'
        %w[E N S]
      when 'S'
        %w[S W E]
      when 'W'
        %w[W N S]
      end
    end

    # Put snek on SnekMath::Matrix arena.
    # Changes matrix
    # @param matrix [SnekMath::Matrix]
    def draw_on(matrix)
      @position.each_with_index do |coords, i|
        coords.symbolize_keys!
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