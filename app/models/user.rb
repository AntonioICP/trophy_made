class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_designs
  has_many :orders

  def admin?
    admin
  end

  def make_admin!
    update!(admin: true)
  end
end
