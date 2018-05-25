class SnekScore

  def initialize(snek)
    @snek = snek
  end

  def score
    @snek.snek_battles.where('created_at >= ?', 2.weeks.ago).sum(:score)
  end

end