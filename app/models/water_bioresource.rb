class WaterBioresource < ApplicationRecord
    has_one :rate_penalty
    has_many :catch_rates
    
    has_one_attached :bioresource_photo

    validates :name, :latin_name, presence: true, uniqueness: { case_sensitive: false }

    validates_each :name, :latin_name do |record, attr, value|
        record.errors.add(attr, I18n.t('errors.messages.first_letter')) if /\A[[:lower:]]/.match?(value)
    end
end
