# frozen_string_literal: true

FactoryBot.define do
  factory :fishing_place do
    name { Faker::Lorem.unique.word.capitalize }
    description { Faker::Lorem.paragraph }
    where_catch { FishingPlace.where_catches.keys.sample }
    user { FactoryBot.create(:user) }
  end
end
