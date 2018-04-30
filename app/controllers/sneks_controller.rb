class SneksController < ApplicationController
  before_action :authenticate_user!

  def index
    @sneks = current_user.sneks
  end

  def new
    @snek = current_user.sneks.build
  end

  def create
    if current_user.sneks.exists?
      redirect_to sneks_path, notice: 'You are not eligible to create more than one snek'
      return
    end
    @snek = current_user.sneks.new
    @snek.name = params[:snek][:name].strip
    if @snek.save
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

end
