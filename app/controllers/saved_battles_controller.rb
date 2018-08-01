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
    saved_battle = current_user.saved_battles.find_by id: params[:id]
    battle = Battle.find params[:battle_id]
    saved_battle.destroy if saved_battle
    redirect_to battle
  rescue ActiveRecord::RecordNotFound
    if battle
      redirect_to battle
    else
      redirect_to root_path
    end
  end

  def index
    @saved_battles = current_user.saved_battles.includes(:battle).order(id: :desc)
  end

end
