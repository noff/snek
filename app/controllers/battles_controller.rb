class BattlesController < ApplicationController

  def create
    @snek = current_user.sneks.find(params[:snek_id])
    # Find opponents
    # Create battle
    # Create relations between sneks and the battle
    # Run battle and save each step and each sneks' stat
    # Finish the battle and write statistics
  end

end
