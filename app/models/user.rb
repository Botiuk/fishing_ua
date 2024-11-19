# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :fishing_places, dependent: :destroy
  has_many :tools, dependent: :destroy
  has_many :fishing_sessions, dependent: :destroy
  has_many :news_stories, dependent: nil

  enum :role, { user: 0, staff: 1, admin: 2 }, prefix: true
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end
end
