class BattlesController < ApplicationController

  def create
    @snek = current_user.sneks.find(params[:snek_id])
    battle = Battle.create!(initiator_snek_id: @snek.id)
    battle.start!
    redirect_to battle
  end

  def show
    @battle = Battle.find params[:id]
  end

end
