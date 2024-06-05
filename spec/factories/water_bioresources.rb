FactoryBot.define do
  factory :water_bioresource do
    name { Faker::Creature::Animal.unique.name.capitalize }
    latin_name { Faker::Artist.name.capitalize + Faker::Number.unique.number(digits: 4).to_s }    
    resource_type { WaterBioresource.resource_types.keys.sample }
  end
end
