class BattlesController < ApplicationController

  def create
    @snek = current_user.sneks.find(params[:snek_id])
    battle = Battle.create!(initiator_snek_id: @snek.id)
    battle.start!
    redirect_to battle
  end

  def show
    @battle = Battle.find params[:id]
    @arena = @battle.arena
    gon.rounds = @battle.battle_rounds.order(:id).map { |round| {sneks: round.sneks, number: round.round_number} }
    gon.snek_names = Hash[@battle.battle_rounds.order(:id).first.sneks.map { |s| [ s['snek_id'], Snek.find(s['snek_id']).name] }]

    gon.snek_parts = []
    SnekStyle::COLORS.shuffle.sample(4).each do |color|
      gon.snek_parts << {
          head: ActionController::Base.helpers.asset_url("snek/head_#{color}.png", type: :image),
          body: ActionController::Base.helpers.asset_url("snek/body_#{color}.png", type: :image),
          tail: ActionController::Base.helpers.asset_url("snek/tail_#{color}.png", type: :image),
          curve: ActionController::Base.helpers.asset_url("snek/curve_#{color}.png", type: :image),
      }
    end

  end

end
