require 'rails_helper'

RSpec.describe Catch, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      catch = build(:catch)
      expect(catch).to be_valid
    end

    it "is not valid without a catch_time" do
      catch = build(:catch, catch_time: nil)
      expect(catch).to_not be_valid
    end

    it "is not valid without a catch_length" do
      catch = build(:catch, catch_length: nil)
      expect(catch).to_not be_valid
    end

    it "is not valid without a catch_weight" do
      catch = build(:catch, catch_weight: nil)
      expect(catch).to_not be_valid
    end

    it "is not valid without a catch_result" do
      catch = build(:catch, catch_result: nil)
      expect(catch).to_not be_valid
    end

    it "is not valid without a fishing_session" do
      catch = build(:catch, fishing_session: nil)
      expect(catch).to_not be_valid
    end

    it "is not valid without a water_bioresource" do
      catch = build(:catch, water_bioresource: nil)
      expect(catch).to_not be_valid
    end
  end
end
