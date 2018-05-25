class PerformBattleJob < ApplicationJob
  queue_as :default

  def perform(battle)
    battle.start!
  end
end
