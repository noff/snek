class SnekScore

  def initialize(snek)
    @snek = snek
  end

  def activity
    @snek.snek_battles.where('created_at >= ?', 2.weeks.ago).sum(:score)
  end

  def efficiency
    @snek.snek_battles.where('created_at >= ?', 2.weeks.ago).count >= 10 ? @snek.snek_battles.where('created_at >= ?', 2.weeks.ago).sum(:score).to_f / @snek.snek_battles.where('created_at >= ?', 2.weeks.ago).count.to_f : 0.00
  end

end