class SavedBattlesController < ApplicationController

  before_action :authenticate_user!

  def create
    battle = Battle.find params[:battle_id]
    unless current_user.saved_battles.where(battle_id: battle.id).exists?
      current_user.saved_battles.create battle_id: battle.id
    end
    redirect_to battle
  end

  def destroy
    saved_battle = current_user.saved_battles.find params[:id]
    battle = saved_battle.battle
    if saved_battle
      saved_battle.destroy
    end
    redirect_to battle
  end

  def index
    @saved_battles = current_user.saved_battles.includes(:battle).order(id: :desc)
  end

end
