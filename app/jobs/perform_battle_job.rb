class PerformBattleJob < ApplicationJob
  queue_as :default

  def perform(battle)
    return if battle.reload.finished?

    # If failed in previous attempt, restart it
    if battle.running?
      battle.restart! true
    else
      battle.start!
    end
  end
end
