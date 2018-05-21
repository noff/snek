class Battle < ApplicationRecord
  include AASM

  belongs_to :snek, class_name: "Snek", foreign_key: "initiator_snek_id", validate: false
  has_many :snek_battles
  has_many :battle_rounds
  belongs_to :arena

  aasm no_direct_assignment: true do
    state :draft, initual: true
    state :running
    state :finished
    state :failed
    event :run do
      transitions from: :draft, to: :running
    end
    event :finish do
      transitions from: :running, to: :finished
    end
    event :fail do
      transitions from: :running, to: :failed, after: Proc.new { |*args| fail_battle(*args) }
    end
  end


  # Perform battle
  # @param initial_snek [Snek]
  # @return Boolean
  def start!

    # Start battle
    run!

    # Find opponents
    sneks = Snek.for_autofight.where.not(id: initiator_snek_id).limit(3)
    unless sneks.exists?
      fail! 'Not enough opponents'
      return false
    end

    # Create snek battles for each snek
    snek_battles.create! snek_id: initiator_snek_id
    sneks.each do |snek|
      snek_battles.create! snek_id: snek.id
    end

    if snek_battles.count < 3
      update! arena_id: 2
    else
      update! arena_id: 1
    end

    # Create arena
    current_arena = arena.reload.get_matrix

    # Get array of all sneks and random sort it
    sneks = snek_battles.map(&:snek).shuffle
    snek_positions = []


    # Put sneks on the arena
    # See README.md – default sneks position
    if arena_id == 1
      sneks.each_with_index do |snek, index|
        position = []
        case index
        when 0 then
          (0..9).each do |i|
            position << { x: 13, y: (11 - i) }
          end
        when 1 then
          (0..9).each do |i|
            position << { x: (15 + i), y: 13 }
          end
        when 2 then
          (0..9).each do |i|
            position << { x: 13, y: (15 + i) }
          end
        when 3 then
          (0..9).each do |i|
            position << { x: (11 - i), y: 13 }
          end
        else
          raise Exception, 'Wrong number of sneks – more than 4'
        end

        # Store to Position model
        snek_position = SnekMath::Position.new(snek, position)
        snek_positions << snek_position

      end
    elsif arena_id == 2
      sneks.each_with_index do |snek, index|
        position = []
        case index
        when 0 then
          (0..9).each do |i|
            position << { x: 2, y: (11 - i) }
          end
        when 1 then
          (0..9).each do |i|
            position << { x: 14, y: (5 + i) }
          end
        else
          raise Exception, 'Wrong number of sneks – more than 4'
        end

        # Store to Position model
        snek_position = SnekMath::Position.new(snek, position)
        snek_positions << snek_position

      end
    else
      raise Exception, 'Not supported arena ID'
    end

    # Put on current_arena (my pointer)
    draw_sneks_on_arena(snek_positions, current_arena)

    # Save current arena to DB
    battle_rounds.create!( round_number: 0, arena: current_arena.area, sneks: snek_positions.map { |p| {snek_id: p.snek.id, position: p.position } } )

    # 10000 steps for a battle (and stop of longer)
    # Run battle and save each step and each sneks' stat
    (1..999).each do |round_number|

      # Flag to break cycle if no snek moved
      any_snek_moved = false

      Rails.logger.info "Round #{round_number}"

      # TODO If all sneks dead, only one winner left, finish the game

      # Cycle sneks
      snek_positions.each_with_index do |snek_position, snek_position_index|

        # Get possible direction for the snek
        move_direction = snek_position.get_next_move(current_arena)

        # Check can we move forward? If not, stay.
        # Do we eat something? If do, move with growth.
        next_x, next_y = snek_position.get_next_coords(move_direction)
        target_cell = current_arena.get(next_x, next_y)

        # If it's impossible to move in this direction, try to get random free direction
        if target_cell == 'wall' || %w[head body].include?(target_cell.split('-')[0])
          move_direction = snek_position.get_random_next_move(current_arena)

          # No free ways, skip round
          next if move_direction.nil?

          # Found free direction
          next_x, next_y = snek_position.get_next_coords(move_direction)
          target_cell = current_arena.get(next_x, next_y)
        end


        if target_cell == 'wall'
          # Can't move into wall.
          raise Exception, 'Tries to move into wall'
        else

          # Tries to move into someones head or body
          if %w[head body].include?(target_cell.split('-')[0])
            # Can't move into body or head or my tail.
            raise Exception, 'Tries to move into body, head or self tail'
          end

          # Tries to move into owns tail. It's ok, just pull the tail forward
          if target_cell == "tail-#{snek_position.snek.id}"
            snek_positions[snek_position_index].move(move_direction, false)
          end

          # Enemy's tail?
          if target_cell.split('-')[0] == 'tail' && target_cell != "tail-#{snek_position.snek.id}"

            # Eat and move
            snek_positions[snek_position_index].move(move_direction, true)

            # Find snek to reduce and reduce it
            snek_positions.each_with_index do |snp, snp_idx|
              next if snp.snek.id == snek_position.snek.id # Don't eat self
              if snp.position.last[:x] == next_x && snp.position.last[:y] == next_y
                snek_positions[snp_idx].position.pop
                Rails.logger.warn "Eat !"
                break
              end
            end

          end

          # Free space?
          if target_cell == 'empty'
            snek_positions[snek_position_index].move(move_direction, false)
          end

        end

        any_snek_moved = true

        # Draw new arena after each move to reflect actual situation
        current_arena = arena.reload.get_matrix
        draw_sneks_on_arena(snek_positions, current_arena)

      end

      # Remove dead sneks
      snek_positions.delete_if { |row| row.position.length < 2 }

      # Dump arena snapshot and sneks positions to DB
      battle_rounds.create!( round_number: round_number, arena: current_arena.area, sneks: snek_positions.map { |p| {snek_id: p.snek.id, position: p.position } } )

      # If no alive sneks except one, finish battle
      if snek_positions.count == 1
        Rails.logger.debug "Battle finished!"
        break
      end

      Rails.logger.info "Sneks stats"
      snek_positions.each do |snek_position|
        Rails.logger.info "Snek ##{snek_position.snek.id}: Length: #{snek_position.position.length}. Head: #{snek_position.position.first.inspect}. Tail: #{snek_position.position.last.inspect}"
      end

      # Stop game if all sneks can't move
      break unless any_snek_moved

    end

    # TODO Write statistics

    # Finish the battle
    finish!

    true

  end


  private

  # Save fail reason to the failed battle
  # @param message [String]
  def fail_battle(message)
    update! fail_reason: message
  end



  # Draw sneks on arena
  # @param snek_positions [Array]
  # @param current_arena [SnekMath::Matrix]
  def draw_sneks_on_arena(snek_positions, current_arena)
    snek_positions.each do |snek_position|
      snek_position.draw_on(current_arena)
    end
    nil
  end


end
