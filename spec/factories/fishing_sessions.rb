FactoryBot.define do
  factory :fishing_session do
    start_time = Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now - 2.days)
    start_at { start_time }
    end_at {  start_time + rand(1..36).hours }
    user { FactoryBot.create(:user) }
    fishing_place { FactoryBot.create(:fishing_place) }
  end
end
