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

    # Get array of all sneks and random sort it
    # position – array of snek's cells and it's coords
    sneks = snek_battles.map { |s| { snek: s.snek, position: []} }.shuffle

    # Create arena
    initial_arena = Arena.find(1).get_matrix
    current_arena = initial_arena

    # Put sneks on the arena
    # See README.md – default sneks position
    sneks.each_with_index do |snek, index|

      case index
      when 0 then
        (0..9).each do |i|
          sneks[index][:position] << { x: 13, y: (11 - i) }
        end
      when 1 then
        (0..9).each do |i|
          sneks[index][:position] << { x: (15 + i), y: 13 }
        end
      when 2 then
        (0..9).each do |i|
          sneks[index][:position] << { x: 13, y: (15 + i) }
        end
      when 3 then
        (0..9).each do |i|
          sneks[index][:position] << { x: (11 - i), y: 13 }
        end
      else
        raise Exception, 'Wrong number of sneks – more than 4'
      end

      # Put on current_arena
      sneks[index][:position].each_with_index do |coords, i|
        if i == 0
          current_arena.set(coords[:x], coords[:y], "head-#{sneks[index][:snek].id}")
        elsif i == sneks[index][:position].length
          current_arena.set(coords[:x], coords[:y], "tail-#{sneks[index][:snek].id}")
        else
          current_arena.set(coords[:x], coords[:y], "body-#{sneks[index][:snek].id}")
        end
      end

    end

    # 10000 steps for a battle (and stop of longer)
    # TODO Run battle and save each step and each sneks' stat
    (0..9999).each do |step|

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
