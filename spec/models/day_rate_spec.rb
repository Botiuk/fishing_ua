# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DayRate do
  it 'is valid with valid attributes' do
    day_rate = build(:day_rate)
    expect(day_rate).to be_valid
  end

  it 'is not valid without a catch_amount' do
    day_rate = build(:day_rate, catch_amount: nil)
    expect(day_rate).not_to be_valid
  end

  it 'is not valid without a amount_type' do
    day_rate = build(:day_rate, amount_type: nil)
    expect(day_rate).not_to be_valid
  end

  it 'is not valid without a water_bioresource' do
    day_rate = build(:day_rate, water_bioresource: nil)
    expect(day_rate).not_to be_valid
  end

  it 'is not valid with same water_bioresource' do
    water_bioresource = create(:water_bioresource)
    create(:day_rate, water_bioresource: water_bioresource)
    day_rate_two = build(:day_rate, water_bioresource: water_bioresource)
    expect(day_rate_two).not_to be_valid
  end

  it 'is not valid when amount_type quatity and catch_amount not integer' do
    day_rate = build(:day_rate, amount_type: 'quantity', catch_amount: 0.1)
    expect(day_rate).not_to be_valid
  end

  it 'is valid when amount_type quatity and catch_amount integer' do
    day_rate = build(:day_rate, amount_type: 'quantity', catch_amount: 1.0)
    expect(day_rate).to be_valid
  end
end
