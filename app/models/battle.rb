class Battle < ApplicationRecord
  include AASM

  belongs_to :snek, class_name: "Snek", foreign_key: "initiator_snek_id", validate: false
  has_many :snek_battles

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

    # Create arena
    initial_arena = Arena.find(1).get_matrix
    current_arena = initial_arena

    # Get array of all sneks and random sort it
    sneks = snek_battles.map(&:snek).shuffle
    snek_positions = []

    # Put sneks on the arena
    # See README.md – default sneks position
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

      # Put on current_arena (my pointer)
      snek_position.draw_on(current_arena)

    end

    current_arena.print

    # 10000 steps for a battle (and stop of longer)
    # TODO Run battle and save each step and each sneks' stat
    (0..9999).each do |step|

      # Cycle sneks
      snek_positions.each_with_index do |snek_position, index|

        # Snek head coordinates on arena
        current_head_coordinates = snek_position.get_head_coords

        # TODO cycle snek's patterns and find matched pattern if possible
        found_pattern = nil
        snek_position.snek.rules.each do |pattern|

          # Get snek's head relative coords in pattern
          pattern_matrix = SnekMath::Pattern.new(pattern)
          snek_head_coords_in_pattern = pattern_matrix.get_my_head_coords

          # Calculate area to snap from arena matrix (pattern width x pattern height)
          # Depending on where my head is set in the pattern
          pattern_width = pattern_matrix.matrix.width
          pattern_height = pattern_matrix.matrix.height

          # Area to cut from arena

          # TODO Get pattern around snek's head
          # depending on where snek head is located and headed in the pattern.
          #

          # TODO Check pattern matches to the current situation
          #
          #
          # TODO If pattern is not match to the current situation,
          # rotate it to three sides randomly and match.
          #
          #
          #

        end

        # TODO If pattern not found, move snek forward if possible (stay in place if not possible)
        # Not possible, if next cell is body, head or wall

        # TODO Check if eat something

        # TODO Move snek in snek position storage

      end

    end


    # Finish the battle
    # TODO and write statistics
    finish!

    true

  end


  private

  # Save fail reason to the failed battle
  # @param message [String]
  def fail_battle(message)
    update! fail_reason: message
  end


end
