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

    # TODO Run battle and save each step and each sneks' stat




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
