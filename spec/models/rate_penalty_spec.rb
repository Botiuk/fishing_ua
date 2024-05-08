require 'rails_helper'

RSpec.describe RatePenalty, type: :model do
    describe "validations" do
        it "is valid with valid attributes" do
            rate_penalty = build(:rate_penalty)
            expect(rate_penalty).to be_valid
        end

        it "is not valid without a water_bioresource" do
            rate_penalty = build(:rate_penalty, water_bioresource: nil)
            expect(rate_penalty).to_not be_valid
        end

        it "is not valid without a money" do
            rate_penalty = build(:rate_penalty, money: nil)
            expect(rate_penalty).to_not be_valid
        end

        it "is not valid when a money is less than 1" do
          rate_penalty = build(:rate_penalty, money: 0)
          expect(rate_penalty).to_not be_valid
        end

        it "is not valid when a money is not number" do
          rate_penalty = build(:rate_penalty, money: "One")
          expect(rate_penalty).to_not be_valid
        end

        it "is not valid when a money is not integer" do
          rate_penalty = build(:rate_penalty, money: 1.5)
          expect(rate_penalty).to_not be_valid
        end
    end
end
