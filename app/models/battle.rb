class Battle < ApplicationRecord
  include AASM

  aasm do
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
      transitions from: :running, to: :failed
    end
  end


end
