FactoryBot.define do
  factory :fishing_place do
    name { Faker::Lorem.unique.word.capitalize }
    description { Faker::Lorem.paragraph }
    where_catch { CatchRate.where_catches.keys.sample }
    user { FactoryBot.create(:user) }
  end
end
