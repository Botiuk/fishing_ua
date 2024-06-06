require 'rails_helper'

RSpec.describe DayRate, type: :model do
  it "is valid with valid attributes" do
    day_rate = build(:day_rate)
    expect(day_rate).to be_valid
  end

  it "is not valid without a catch_amount" do
    day_rate = build(:day_rate, catch_amount: nil)
    expect(day_rate).to_not be_valid
  end

  it "is not valid without a amount_type" do
    day_rate = build(:day_rate, amount_type: nil)
    expect(day_rate).to_not be_valid
  end
  
  it "is not valid without a water_bioresource" do
    day_rate = build(:day_rate, water_bioresource: nil)
    expect(day_rate).to_not be_valid
  end

  it "is not valid with same water_bioresource" do
    water_bioresource = create(:water_bioresource)
    day_rate_one = create(:day_rate, water_bioresource: water_bioresource)
    day_rate_two = build(:day_rate, water_bioresource: water_bioresource)
    expect(day_rate_two).to_not be_valid
  end
end
