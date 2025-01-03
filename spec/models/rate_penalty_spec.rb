# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatePenalty do
  describe 'validations' do
    it 'is valid with valid attributes' do
      rate_penalty = build(:rate_penalty)
      expect(rate_penalty).to be_valid
    end

    it 'is not valid without a water_bioresource' do
      rate_penalty = build(:rate_penalty, water_bioresource: nil)
      expect(rate_penalty).not_to be_valid
    end

    it 'is not valid with same water_bioresource' do
      water_bioresource = create(:water_bioresource)
      create(:rate_penalty, water_bioresource: water_bioresource)
      rate_penalty_two = build(:rate_penalty, water_bioresource: water_bioresource)
      expect(rate_penalty_two).not_to be_valid
    end

    it 'is not valid without a money' do
      rate_penalty = build(:rate_penalty, money: nil)
      expect(rate_penalty).not_to be_valid
    end

    it 'is not valid when a money is less than 1' do
      rate_penalty = build(:rate_penalty, money: 0)
      expect(rate_penalty).not_to be_valid
    end

    it 'is not valid when a money is not number' do
      rate_penalty = build(:rate_penalty, money: 'One')
      expect(rate_penalty).not_to be_valid
    end

    it 'is not valid when a money is not integer' do
      rate_penalty = build(:rate_penalty, money: 1.5)
      expect(rate_penalty).not_to be_valid
    end
  end
end
