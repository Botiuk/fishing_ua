FactoryBot.define do
  factory :catch_rate do
    water_bioresource { FactoryBot.create(:water_bioresource) }
    where_catch { rand(0..3) }
    length { Faker::Number.decimal(l_digits: 2, r_digits: 1) }
  end
end
