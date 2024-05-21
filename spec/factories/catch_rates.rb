FactoryBot.define do
  factory :catch_rate do
    water_bioresource { FactoryBot.create(:water_bioresource) }
    where_catch { CatchRate.where_catches.keys.sample }
    length { Faker::Number.decimal(l_digits: 2, r_digits: 1) }
  end
end
