# frozen_string_literal: true

FactoryBot.define do
  factory :tool_catch do
    tool { FactoryBot.create(:tool) }
    catch { FactoryBot.create(:catch) }
  end
end
