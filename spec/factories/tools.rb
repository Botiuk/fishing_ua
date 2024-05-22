FactoryBot.define do
  factory :tool do
    name { Faker::Coin.unique.name }
    description { Faker::Quote.yoda }
    user { FactoryBot.create(:user) }
  end
end
