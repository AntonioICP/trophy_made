class Product < ApplicationRecord
  has_many :user_designs
  has_many :order_items
  has_many :orders, through: :order_items
end
