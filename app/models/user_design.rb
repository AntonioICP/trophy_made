class UserDesign < ApplicationRecord
  belongs_to :product
  belongs_to :user, optional: true
  belongs_to :order

  has_one_attached :design_image
end
