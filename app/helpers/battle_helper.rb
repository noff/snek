module BattleHelper

  def battle_name(battle)
    case battle.mode
    when BattleMode::DEFAULT
      "Battle ##{battle.id}"
    when BattleMode::DUEL
      "Duel ##{battle.id}"
    when BattleMode::BATTLE_ROYALE
      "👑 Battle Royale ##{battle.id}"
    else
      "Battle ##{battle.id}"
    end
  end

end
