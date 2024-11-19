# frozen_string_literal: true

class NewsStory < ApplicationRecord
  belongs_to :user

  has_one_attached :cover
  has_rich_text :content

  validates :title, presence: true

  validates_each :title do |record, attr, value|
    record.errors.add(attr, I18n.t('errors.messages.first_letter')) if /\A[[:lower:]]/.match?(value)
  end
end
