# frozen_string_literal: true

FactoryBot.define do
  factory :catch do
    catch_time { Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now) }
    catch_length { Faker::Number.decimal(l_digits: 2, r_digits: 1) }
    catch_weight { Faker::Number.decimal(l_digits: 1, r_digits: 3) }
    catch_result { 'set_free' }
    fishing_session { FactoryBot.create(:fishing_session) }
    water_bioresource { FactoryBot.create(:water_bioresource) }
  end
end
