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

    sneks = Snek.select(:id, :name).map { |snek| {snek: snek, activity_score: SnekScore.new(snek).activity, efficiency_score: SnekScore.new(snek).efficiency, activity_position: 0, efficiency_position: 0  } }

    # Calculate efficiency position
    sneks.sort! { |a,b| a[:efficiency_score] <=> b[:efficiency_score] }
    sneks.reverse!
    sneks.each_with_index do |v, k|
      sneks[k][:efficiency_position] = k + 1
    end

    # Calculate activity position
    sneks.sort! { |a,b| a[:activity_score] <=> b[:activity_score] }
    sneks.reverse!
    sneks.each_with_index do |v, k|
      sneks[k][:activity_position] = k + 1
    end

    sneks.each do |snek|
      row = DailyRating.find_by(snek_id: snek[:snek].id, date: date)
      if row
        row.update activity_position: snek[:activity_position],
                   activity_score: snek[:activity_score],
                   efficiency_position: snek[:efficiency_position],
                   efficiency_score: snek[:efficiency_score]
      else
        DailyRating.create! snek_id: snek[:snek].id,
                            date: date,
                            activity_position: snek[:activity_position],
                            activity_score: snek[:activity_score],
                            efficiency_position: snek[:efficiency_position],
                            efficiency_score: snek[:efficiency_score]
      end
    end

    # TODO send notifications about status change
  end

end