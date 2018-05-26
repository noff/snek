class BattlesController < ApplicationController

  def index
  end

  def create
    @snek = current_user.sneks.find(params[:snek_id])
    battle = Battle.create!(initiator_snek_id: @snek.id)
    PerformBattleJob.perform_later battle
    redirect_to battle
  end

  def show
    @battle = Battle.find params[:id]
    if @battle.finished?
      @arena = @battle.arena
      gon.rounds = @battle.battle_rounds.order(:id).map { |round| {sneks: round.sneks, number: round.round_number} }
      gon.snek_names = Hash[@battle.battle_rounds.order(:id).first.sneks.map { |s| [ s['snek_id'], Snek.find(s['snek_id']).name] }]
      gon.sneks = Hash[@battle.snek_battles.map { |sb| [sb.snek.id.to_s, { id: sb.snek.id, name: sb.snek.name, style: sb.snek.style_asset_urls}] }]
    end
  end

end
