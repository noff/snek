class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sneks
  has_many :saved_battles
  has_many :paid_subscriptions
  has_many :subscription_payments

  def to_s
    email
  end

end
