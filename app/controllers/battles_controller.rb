class BattlesController < ApplicationController

  def index; end

  def create
    @snek = current_user.sneks.find(params[:snek_id])

    if @snek.too_much_battles?

      redirect_to @snek, alert: "You are running #{@snek.current_battles_count} battles simultaneously. You can run new battles after these battles finish. Please, wait few minutes :)"

    else

      # Don't allow to run battle royale without crowns
      mode = params[:mode].to_i
      mode = BattleMode::ALL.include?(mode) ? mode : BattleMode::DEFAULT
      if mode == BattleMode::BATTLE_ROYALE && current_user.crowns < 1
        mode = BattleMode::DEFAULT
      end

      # If battle royale and has crowns, reduce crowns
      if mode == BattleMode::BATTLE_ROYALE && current_user.crowns > 0
        current_user.decrement!(:crowns)
      end

      battle = Battle.create!(initiator_snek_id: @snek.id, mode: mode)
      PerformBattleJob.perform_later battle
      redirect_to battle

    end

  end

  def show
    @battle = Battle.find params[:id]
    if @battle.finished?
      @arena = @battle.arena
      gon.rounds = @battle.battle_rounds.order(:id).map { |round| {sneks: round.sneks, number: round.round_number} }
      gon.snek_names = Hash[@battle.battle_rounds.order(:id).first.sneks.map { |s| [ s['snek_id'], Snek.find(s['snek_id']).short_name] }]
      gon.sneks = Hash[@battle.snek_battles.map { |sb| [sb.snek.id.to_s, { id: sb.snek.id, name: sb.snek.short_name, style: sb.snek.style_asset_urls}] }]
    end
  end

  def image
    @battle = Battle.find params[:id]
    send_data BattleImage.new(@battle).for_facebook,
              type: 'image/png',
              disposition: 'inline',
              quality: 90,
              filename: "battle-#{@battle.id}.png"
  end

end
