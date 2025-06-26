class Product < ApplicationRecord
  has_many :user_design
  has_many :order_item
  has_many :order
end
