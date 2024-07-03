FactoryBot.define do
  factory :news_story do
    title { Faker::Movie.title.capitalize }
    user { FactoryBot.create(:user) }
  end
end
