class AddStyleToSnek < ActiveRecord::Migration[5.2]
  def change
    add_column :sneks, :color, :string
    add_column :sneks, :pattern, :string
    add_column :sneks, :pattern_color, :string
    Snek.all.each do |snek|
      snek.update color: SnekStyle::COLORS.sample,
                  pattern: SnekStyle::PATTERNS.sample,
                  pattern_color: SnekStyle::PATTERN_COLORS.sample
    end
  end
end
