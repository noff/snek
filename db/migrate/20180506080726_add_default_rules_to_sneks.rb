class AddDefaultRulesToSneks < ActiveRecord::Migration[5.2]
  def change
    Snek.where(rules: nil).update_all rules: Snek.new.fetch_rules
  end
end
