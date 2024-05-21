require 'rails_helper'

RSpec.describe FishingPlace, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      fishing_place = build(:fishing_place)
      expect(fishing_place).to be_valid
    end

    it "is not valid without a name" do
      fishing_place = build(:fishing_place, name: nil)
      expect(fishing_place).to_not be_valid
    end

    it "is valid without a description" do
      fishing_place = build(:fishing_place, description: nil)
      expect(fishing_place).to be_valid
    end

    it "is not valid without a where_catch" do
      fishing_place = build(:fishing_place, where_catch: nil)
      expect(fishing_place).to_not be_valid
    end

    it "is not valid with same name and same user" do
      user = create(:user)
      fishing_place_one = create(:fishing_place, user: user)
      fishing_place_two = build(:fishing_place, user: user, name: fishing_place_one.name)
      expect(fishing_place_two).to_not be_valid
    end

    it "is not valid with same name and same user, false case sensitive for name" do
      user = create(:user)
      fishing_place_one = create(:fishing_place, user: user, name: "My lake")
      fishing_place_two = build(:fishing_place, user: user, name: "my LAKE")
      expect(fishing_place_two).to_not be_valid
    end

    it "is valid with same name but different users" do
      user_one = create(:user)
      user_two = create(:user)
      fishing_place_one = create(:fishing_place, user: user_one)
      fishing_place_two = build(:fishing_place, user: user_two, name: fishing_place_one.name)
      expect(fishing_place_two).to be_valid
    end
  end
end
