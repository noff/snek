class SneksController < ApplicationController
  before_action :authenticate_user!

  def index
    @sneks = current_user.sneks
  end

  def new
    @snek = current_user.sneks.build
    ahoy.track 'New Snek Form'
  end

  def create

    if current_user.sneks.exists? && current_user.paid_subscriptions.count == 0
      redirect_to sneks_path, notice: 'You are not eligible to create more than one snek'
      return
    end

    if current_user.paid_subscriptions.count <= (current_user.sneks.count - 1)
      redirect_to sneks_path, notice: 'You are not eligible to get more sneks. Please, buy new PRO slot'
      return
    end

    # Is snek PRO?
    # Also check if user didn't create free snek
    is_pro = current_user.paid_subscriptions.count > (current_user.sneks.count - 1) && current_user.paid_subscriptions.count > 0

    @snek = current_user.sneks.new
    @snek.name = params[:snek][:name].strip
    @snek.pro = is_pro
    if @snek.save
      flash[:just_created_snek] = true
      ahoy.track 'New Snek Created'
      redirect_to sneks_path, notice: 'Your new snek is ready!'
    else
      render 'new'
    end
  end

  def destroy
    # Don't delete sneks
    raise StandardError, 'You can not delete sneks, sorry'
  end

  def show
    @snek = current_user.sneks.find(params[:id])
    @snek_battles = @snek.snek_battles.order(id: :desc).page(params[:page] || 0)
  end

  def rules
    @snek = current_user.sneks.find(params[:id])
    gon.snek_rules = @snek.fetch_rules
    ahoy.track 'Open Rules Editor', {snek_id: @snek.id}
  end

  def save_rules
    @snek = current_user.sneks.find(params[:id])
    # raise JSON.parse(params[:snek][:rules])[0].inspect
    @snek.rules = JSON.parse(params[:snek][:rules])
    if @snek.save
      flash[:just_saved_rules] = true
      redirect_to @snek, notice: 'Rules saved'
    else
      redirect_to @snek, alert: "Rules invalid, did not saved. Errors: #{@snek.errors.messages[:rules].join(', ') }"
    end
  end

  # Enables or disables auto fight mode
  def auto_fight
    @snek = current_user.sneks.find(params[:id])
    if params[:mode] == 'on'
      @snek.update auto_fight: true
    else
      @snek.update auto_fight: false
    end
    redirect_to @snek, notice: 'Autofight mode changed'
  end

  def test_pattern
    battle = Battle.find params[:battle_id]
    battle_round = battle.battle_rounds.find_by(round_number: params[:round])
    sneks = battle_round.sneks
    snek = Snek.find params[:snek_id]
    pattern = JSON.parse params[:pattern]
    current_arena = battle.arena.get_matrix

    # Store to Position model
    snek_positions = sneks.map { |s|  SnekMath::Position.new( Snek.find(s['snek_id']), s['position']) }

    # Draw sneks on position
    snek_positions.each do |snek_position|
      snek_position.draw_on(current_arena)
    end

    # Take only needed snek
    snek_position = snek_positions.select { |sp| sp.snek.id == snek.id }.first

    # Check move position
    (move_direction, pattern_index) = snek_position.get_next_move(current_arena)

    render json: {direction: move_direction, pattern: pattern_index}
  end

end
