class PaidSubscription < ApplicationRecord

  PRODUCTS = [
      {product: 'pro_snek', price: 300}
  ].freeze

  scope :paid, -> { where('paid_till >= ?', Date.current) }

  class << self
    # Returns product's price in cents
    # @return Integer
    def product_price(product)
      PRODUCTS.each do |product_data|
        return product_data[:price] if product_data[:product] == product
      end
      raise Exception, 'Incorrect product code'
    end
  end


  has_many :subscription_payments
  belongs_to :user
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :product, inclusion: { in: PRODUCTS.map { |x| x[:product] }  }
end
