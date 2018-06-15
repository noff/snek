class PerformBattleJob < ApplicationJob
  queue_as :default

  def perform(battle, options = {})
    return if battle.reload.finished?

    # If failed in previous attempt, restart it
    if battle.running?
      battle.restart! true, options
    else
      battle.start! options
    end
  end
end
