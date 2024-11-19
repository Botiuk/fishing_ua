# frozen_string_literal: true

FactoryBot.define do
  factory :tool do
    name { Faker::Coin.unique.name }
    description { Faker::Quote.yoda }
    tool_type { Tool.tool_types.keys.sample }
    user { FactoryBot.create(:user) }
  end
end
