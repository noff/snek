class Battle < ApplicationRecord
  include AASM
  visitable
  paginates_per 50

  belongs_to :snek, class_name: "Snek", foreign_key: "initiator_snek_id", validate: false
  has_many :snek_battles
  has_many :battle_rounds
  has_many :saved_battles
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
    event :draft do
      transitions from: :failed, to: :draft
      transitions from: :running, to: :draft
    end
  end


  # @return String
  def name
    "Battle ##{id} #{mode == BattleMode::BATTLE_ROYALE ? '👑': '' }".strip
  end


  # Restart failed battle
  def restart!(sure = false, options = {})
    if sure
      battle_rounds.destroy_all
      snek_battles.destroy_all
      draft!
      start! options
    else
      Rails.logger.warn 'You are not sure to restart this battle'
    end
  end


  # Perform battle
  # @param initial_snek [Snek]
  # @return Boolean
  def start!(options = {})

    # Start battle
    run!

    case mode
    when BattleMode::DEFAULT
      sneks = Snek.for_autofight.active.where.not(id: initiator_snek_id).shuffle.take(3)
      if sneks.count < 3
        sneks = sneks.take(1)
        update! mode: BattleMode::DUEL
      end
    when BattleMode::DUEL
      if options[:opponent_snek]
        sneks = [options[:opponent_snek]]
      else
        sneks = Snek.for_autofight.where.not(id: initiator_snek_id).shuffle.take(1)
      end
    when BattleMode::BATTLE_ROYALE
      sneks = Snek.for_autofight.where.not(id: initiator_snek_id).shuffle.take(8)
    end

    # Find opponents
    unless sneks.any?
      fail! 'Not enough opponents'
      return false
    end

    # Create snek battles for each snek
    snek_battles.create! snek_id: initiator_snek_id
    sneks.each do |snek|
      snek_battles.create! snek_id: snek.id
    end

    # Choose arena
    update! arena_id: (mode == BattleMode::DUEL ? 2 : 1)

    # Create arena
    current_arena = arena.get_matrix

    # Get array of all sneks and random sort it
    sneks = snek_battles.map(&:snek).shuffle

    # Put sneks on default positions
    snek_positions = put_sneks_on_positions sneks, arena_id

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

      # Cycle sneks
      snek_positions.each_with_index do |snek_position, snek_position_index|

        # Get possible direction for the snek
        # Try to catch https://rollbar.com/noff/snek/items/30/
        begin
          (move_direction, pattern_index) = snek_position.get_next_move(current_arena)
        rescue NoMethodError => e
          Rollbar.error e,
                        snek_positions: snek_positions,
                        snek_position_index: snek_position_index,
                        snek_position: snek_position,
                        current_arena: current_arena,
                        round_number: round_number,
                        battle_id: id
          raise NoMethodError
        end

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

          # Tries to move into owns tail. It's ok if snek is longer than 2, so it doesn't "flip"
          if target_cell == "tail-#{snek_position.snek.id}" && snek_position.position.length > 2
            # just pull the tail forward
            snek_positions[snek_position_index].move(move_direction, false)
          end

          # Enemy's tail?
          if target_cell.split('-')[0] == 'tail' && target_cell != "tail-#{snek_position.snek.id}"

            # Eat and move
            # Try to catch https://rollbar.com/noff/snek/items/30/
            begin
              snek_positions[snek_position_index].move(move_direction, true)
            rescue NoMethodError
              Rollbar.error NoMethodError, "undefined method `[]' for nil:NilClass",
                            snek_positions: snek_positions,
                            snek_position_index: snek_position_index,
                            snek_position: snek_position,
                            target_cell: target_cell,
                            move_direction: move_direction,
                            current_arena: current_arena,
                            round_number: round_number,
                            battle_id: id
              raise NoMethodError
            end

            # Find snek to reduce and reduce it
            snek_positions.each_with_index do |snp, snp_idx|
              next if snp.snek.id == snek_position.snek.id # Don't eat self
              if snp.position.last[:x] == next_x && snp.position.last[:y] == next_y
                snek_positions[snp_idx].position.pop
                Rails.logger.warn "Eat !"

                # Remove dead snek
                if snek_positions[snp_idx].position.length < 2
                  snek_positions.delete_at(snp_idx)
                end

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
        current_arena = arena.get_matrix
        draw_sneks_on_arena(snek_positions, current_arena)

      end

      # Remove dead sneks
      snek_positions.delete_if { |row| row.position.length < 2 }

      # Dump arena snapshot and sneks positions to DB
      battle_rounds.create!( round_number: round_number, arena: current_arena.area, sneks: snek_positions.map { |p| {snek_id: p.snek.id, position: p.position } } )

      # If no alive sneks except one, finish battle and give a crown
      if snek_positions.count == 1
        snek_positions.first.snek.user.increment!(:crowns)
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

    # Write statistics. Leave default 0 for dead sneks
    snek_positions.each do |snek_position|
      SnekBattle.find_by(battle_id: id, snek_id: snek_position.snek.id).update score: snek_position.position.length
    end

    # Finish the battle
    finish!
    snek.decrement!(:current_battles_count)

    true

  end


  private

  # Save fail reason to the failed battle
  # @param message [String]
  def fail_battle(message)
    snek.decrement!(:current_battles_count)
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


  # Put sneks on default positions
  # @param sneks [Array]
  # @param arena_id [Fixnum]
  # @return Array
  def put_sneks_on_positions(sneks, arena_id)

    snek_positions = []

    # See README.md – default sneks position

    case mode

    when BattleMode::DEFAULT

      raise(Exception, 'Incorrect area for default battle mode') if arena_id != 1

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

    when BattleMode::DUEL

      raise(Exception, 'Incorrect area for duel battle mode') if arena_id != 2

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

    when BattleMode::BATTLE_ROYALE

      raise(Exception, 'Incorrect area for battle royale mode') if arena_id != 1

      sneks.each_with_index do |snek, index|
        position = []
        case index
        when 0 then
          (0..9).each do |i|
            position << { x: 3, y: (11 - i) }
          end
        when 1 then
          (0..9).each do |i|
            position << { x: 5, y: (15 + i) }
          end
        when 2 then
          (0..9).each do |i|
            position << { x: 8, y: (11 - i) }
          end
        when 3 then
          (0..9).each do |i|
            position << { x: 10, y: (15 + i) }
          end
        when 4 then
          (0..9).each do |i|
            position << { x: 13, y: (11 - i) }
          end
        when 5 then
          (0..9).each do |i|
            position << { x: 16, y: (15 + i) }
          end
        when 6 then
          (0..9).each do |i|
            position << { x: 18, y: (11 - i) }
          end
        when 7 then
          (0..9).each do |i|
            position << { x: 21, y: (15 + i) }
          end
        when 8 then
          (0..9).each do |i|
            position << { x: 23, y: (11 - i) }
          end
        else
          raise Exception, 'Wrong number of sneks – more than 4'
        end

        # Store to Position model
        snek_position = SnekMath::Position.new(snek, position)
        snek_positions << snek_position

      end

    else
      raise Exception, 'Not supported battle mode'
    end


    # Return
    snek_positions

  end


end
