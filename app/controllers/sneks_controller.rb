class SneksController < ApplicationController
  before_action :authenticate_user!

  def index
    @sneks = current_user.sneks
  end

  def new
    @snek = current_user.sneks.build
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
    is_pro = current_user.paid_subscriptions.count > (current_user.sneks.count - 1)

    @snek = current_user.sneks.new
    @snek.name = params[:snek][:name].strip
    @snek.pro = is_pro
    if @snek.save
      flash[:just_created_snek] = true
      redirect_to sneks_path, notice: 'Your new snek is ready!'
    else
      render 'new'
    end
  end

  def destroy
    @snek = current_user.sneks.find(params[:id])
    @snek.destroy
    redirect_to sneks_path, notice: "Rest in peace, #{@snek.name}"
  end

  def show
    @snek = current_user.sneks.find(params[:id])
  end

  def rules
    @snek = current_user.sneks.find(params[:id])
    gon.snek_rules = @snek.fetch_rules
  end

  def save_rules
    @snek = current_user.sneks.find(params[:id])
    # raise JSON.parse(params[:snek][:rules])[0].inspect
    @snek.rules = JSON.parse(params[:snek][:rules])
    if @snek.save
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

end
