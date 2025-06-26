class Order < ApplicationRecord
  belongs_to :product
  belongs_to :user
  has_many :order_item
  has_many :user_design
end
