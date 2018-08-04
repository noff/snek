class SnekScore

  def initialize(snek)
    @snek = snek
  end

  def activity
    @snek.snek_battles.where('created_at >= ?', 2.weeks.ago).sum(:score)
  end

  def efficiency
    @snek.snek_battles.where('created_at >= ?', 2.weeks.ago).exists? ? @snek.snek_battles.where('created_at >= ?', 2.weeks.ago).sum(:score) / @snek.snek_battles.where('created_at >= ?', 2.weeks.ago).count : 0
  end

end