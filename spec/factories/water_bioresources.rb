FactoryBot.define do
  factory :water_bioresource do
    name { Faker::Creature::Animal.unique.name.capitalize }
    latin_name { Faker::Artist.unique.name.capitalize }
  end
end
