require 'rails_helper'

RSpec.describe CatchRate, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      catch_rate = build(:catch_rate)
      expect(catch_rate).to be_valid
    end

    it "is not valid without a water_bioresource" do
      catch_rate = build(:catch_rate, water_bioresource: nil)
      expect(catch_rate).to_not be_valid
    end

    it "is not valid without a where_catch" do
      catch_rate = build(:catch_rate, where_catch: nil)
      expect(catch_rate).to_not be_valid
    end

    it "is not valid without a length" do
      catch_rate = build(:catch_rate, length: nil)
      expect(catch_rate).to_not be_valid
    end

    it "is valid with same water_bioresource but different where_catch" do
      water_bioresource = create(:water_bioresource)
      catch_rate_one = create(:catch_rate, water_bioresource: water_bioresource, where_catch: 1)
      catch_rate_two = build(:catch_rate, water_bioresource: water_bioresource, where_catch: 2)
      expect(catch_rate_two).to be_valid
    end

    it "is not valid with same enum where_catch for water_bioresource" do
      water_bioresource = create(:water_bioresource)
      catch_rate_one = create(:catch_rate, water_bioresource: water_bioresource, where_catch: 1)
      catch_rate_two = build(:catch_rate, water_bioresource: water_bioresource, where_catch: 1)
      expect(catch_rate_two).to_not be_valid
    end

    it "is not valid when a length is less than 0" do
      catch_rate = build(:catch_rate, length: -0.1)
      expect(catch_rate).to_not be_valid
    end

    it "is not valid when a length is not number" do
      catch_rate = build(:catch_rate, length: "Ten")
      expect(catch_rate).to_not be_valid
    end

    it "is valid when a length is integer" do
      catch_rate = build(:catch_rate, length: 42)
      expect(catch_rate).to be_valid
    end
  end
end
