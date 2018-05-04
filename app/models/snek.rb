class Snek < ApplicationRecord
  belongs_to :user

  validates :name,
            uniqueness:   { case_sensitive: false },
            presence:     true,
            length:       { minimum: 5 }
  validates :user_id, presence: true


  # Fetch rules or create empty set if rules are null
  def fetch_rules
    update rules: rules_template if rules.nil?
    rules
  end

  private

  # Empty rules template - single pattern
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

end
