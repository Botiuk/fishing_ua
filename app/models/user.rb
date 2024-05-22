class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :catch_rates
  has_many :fishing_places
  has_many :tools

  enum :role, { user: 0, staff: 1, admin: 2 }, prefix: true
  after_initialize :set_default_role, if: :new_record?  

  def set_default_role
    self.role ||= :user
  end
end
