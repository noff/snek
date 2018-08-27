class Snek < ApplicationRecord
  visitable

  belongs_to :user
  has_many :started_battles,
           foreign_key: "initiator_snek_id",
           class_name: 'Battle'
  has_many :snek_battles
  has_many :daily_ratings

  validates :name,
            uniqueness:   { case_sensitive: false },
            presence:     true,
            length:       { minimum: 5, maximum: 30 }
  validates :user_id, presence: true
  validate :rules_must_be_correct

  before_validation :assign_default_rules
  after_create :generate_random_style
  after_create :set_country_if_not_set

  scope :for_autofight, -> { where(auto_fight: true) }
  scope :pro, -> { where(pro: true) }
  scope :not_pro, -> { where(pro: false) }
  scope :active, -> { where(active: true) }

  def to_s
    name
  end

  # Fetch rules or create empty set if rules are null
  # @return Array
  def fetch_rules
    update rules: rules_template if rules.nil?
    rules
  end

  # Remove duplicate patterns and returns only patterns ready to fight
  # @return Array
  def rules_for_fight
    rules.uniq
  end

  # Get short name
  # @return String
  def short_name
    name.truncate(15)
  end

  # Returns path to assets of snek's style
  # @return Hash
  def style_asset_urls
    {
        head: ActionController::Base.helpers.asset_url("snek/head_#{color}.png", type: :image),
        body: ActionController::Base.helpers.asset_url("snek/body_#{color}.png", type: :image),
        curve: ActionController::Base.helpers.asset_url("snek/curve_#{color}.png", type: :image),
        tail: ActionController::Base.helpers.asset_url("snek/tail_#{color}.png", type: :image),
        body_pattern: ActionController::Base.helpers.asset_url("skin/pattern_#{pattern}_body_#{pattern_color}.png", type: :image),
        tail_pattern: ActionController::Base.helpers.asset_url("skin/pattern_#{pattern}_tail_#{pattern_color}.png", type: :image),
        curve_pattern: ActionController::Base.helpers.asset_url("skin/pattern_#{pattern}_curve_#{pattern_color}.png", type: :image),
    }
  end

  # Generate random style
  def generate_random_style
    if color.nil? || pattern.nil? || pattern_color.nil?
      update  color: SnekStyle::COLORS.sample,
              pattern: SnekStyle::PATTERNS.sample,
              pattern_color: SnekStyle::PATTERN_COLORS.sample
    end
  end


  # Check number of currently processing battles for Snek
  # Snek can't run more than 3 simultaneously battles
  # @return Boolean
  def too_much_battles?
    current_battles_count >= 3
  end

  # Set snek country
  def set_country_if_not_set
    if country.nil? && !user.current_sign_in_ip.nil?
      geo_db = MaxMindDB.new('./vendor/GeoLite2-City.mmdb')
      country = geo_db.lookup(user.current_sign_in_ip.to_s).country.name
      if country
        update country: country
      end
    end
  end



  private

  # Empty rules template - single pattern
  # @return Array
  def rules_template
    9.times.map do
      [
          [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']],
          [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']],
          [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']],
          [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['my_head', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']],
          [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']],
          [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']],
          [ ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and'], ['default', 'and']],
      ]
    end
  end

  def rules_must_be_correct
    errors.add(:rules, 'must be an Array') unless rules.is_a?(Array)
    errors.add(:rules, 'must be an Array of 9 patterns') if rules.length != 9
    rules.each_with_index do |pattern, index|
      errors.add(:rules, "Pattern #{index} must be an Array") unless pattern.is_a?(Array)
      errors.add(:rules, "Pattern #{index} must have exact 7 rows") if pattern.length != 7
      errors.add(:rules, "Pattern #{index} must be 7x7 cells") if pattern.flatten.length != 98 # 49 times per 2 elements
      errors.add(:rules, "Pattern #{index} must have one and only one my head") if pattern.flatten.select{ |cell| cell == 'my_head' }.length != 1
      errors.add(:rules, "Pattern #{index} has forbidden values") if (pattern.flatten.uniq - ["and", "default", "empty", "enemy_body", "enemy_head", "enemy_tail", "my_body", "my_head", "my_tail", "not", "or", "wall"]).count > 0
    end
  end

  # When create new snek, assign default rules
  def assign_default_rules
    if rules.nil?
      self.rules = rules_template
    end
  end



end
