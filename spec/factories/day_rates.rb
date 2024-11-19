# frozen_string_literal: true

FactoryBot.define do
  factory :day_rate do
    catch_amount { Faker::Number.between(from: 0, to: 30) }
    amount_type { 'weight' }
    water_bioresource { FactoryBot.create(:water_bioresource) }
  end
end
