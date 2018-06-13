class DailyRatingCalculator

  attr_accessor :date

  class << self
    def perform_today
      DailyRatingCalculator.new(Date.current).perform
    end
  end

  def initialize(date)
    @date = date
  end

  def perform
    sneks_with_positions = Snek.all.map do |snek|
      [snek, SnekScore.new(snek).score]
    end.sort { |a, b| a[1] <=> b[1] }.reverse

    sneks_with_positions.each do |rating|
      row = DailyRating.find_by(snek_id: rating[0].id, date: date)
      if row
        row.update position: rating[1]
      else
        DailyRating.create! snek_id: rating[0].id, date: date, position: rating[1]
      end
    end

    # TODO send notifications about status change
  end

end