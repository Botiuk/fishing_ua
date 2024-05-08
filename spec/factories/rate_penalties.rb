FactoryBot.define do
  factory :rate_penalty do
    water_bioresource { FactoryBot.create(:water_bioresource) }
    money { Faker::Number.between(from: 1000, to: 5000) }
  end
end
