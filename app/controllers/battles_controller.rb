class BattlesController < ApplicationController

  def create
    @snek = current_user.sneks.find(params[:snek_id])
    battle = Battle.create!
    battle.run(@snek)
    redirect_to battle
  end

end
