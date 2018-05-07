class Battle < ApplicationRecord
  include AASM

  aasm no_direct_assignment: true do
    state :draft, initual: true
    state :running
    state :finished
    state :failed
    event :run do
      transitions from: :draft, to: :running, after: Proc.new { |*args| perform_battle(*args) }
    end
    event :finish do
      transitions from: :running, to: :finished
    end
    event :fail do
      transitions from: :running, to: :failed
    end
  end


  private

  # Perform battle
  # @param initial_snek [Snek]
  # @return nil
  def perform_battle(initial_snek)
    raise initial_snek.id.inspect
    # Find opponents
    # Create battle
    # Create relations between sneks and the battle
    # Run battle and save each step and each sneks' stat
    # Finish the battle and write statistics
  end


end
