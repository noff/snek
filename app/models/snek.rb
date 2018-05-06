class Snek < ApplicationRecord
  belongs_to :user

  validates :name,
            uniqueness:   { case_sensitive: false },
            presence:     true,
            length:       { minimum: 5 }
  validates :user_id, presence: true
  validate :rules_must_be_correct

  before_validation :assign_default_rules

  scope :for_autofight, -> { where(auto_fight: true) }

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
    end
  end

  # When create new snek, assign default rules
  def assign_default_rules
    if rules.nil?
      self.rules = rules_template
    end
  end

end
