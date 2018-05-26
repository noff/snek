class PerformBattleJob < ApplicationJob
  queue_as :default

  def perform(battle)
    # If failed in previous attempt, restart it
    if battle.running?
      battle.restart! true
    else
      battle.start!
    end
  end
end
