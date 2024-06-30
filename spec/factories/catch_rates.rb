FactoryBot.define do
  factory :catch_rate do
    water_bioresource { FactoryBot.create(:water_bioresource) }
    length_dnipro { [nil, 0.0, 5.5, 10.1].sample }
    length_other { Faker::Number.decimal(l_digits: 2, r_digits: 1) }
    length_black { Faker::Number.decimal(l_digits: 2, r_digits: 1) }
    length_azov { Faker::Number.decimal(l_digits: 2, r_digits: 1) }
  end
end
