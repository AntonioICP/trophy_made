class Product < ApplicationRecord
  has_and_belongs_to_many :corporate_categories
  has_and_belongs_to_many :sports
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :product_styles
  belongs_to :quality, optional: true

  has_many :user_designs
  has_many :order_items
  has_many :orders, through: :order_items
end
