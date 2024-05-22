require 'rails_helper'

RSpec.describe Equipment, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      equipment = build(:equipment)
      expect(equipment).to be_valid
    end

    it "is not valid without a name" do
      equipment = build(:equipment, name: nil)
      expect(equipment).to_not be_valid
    end

    it "is valid without a description" do
      equipment = build(:equipment, description: nil)
      expect(equipment).to be_valid
    end

    it "is not valid with same name and same user" do
      user = create(:user)
      equipment_one = create(:equipment, user: user)
      equipment_two = build(:equipment, user: user, name: equipment_one.name)
      expect(equipment_two).to_not be_valid
    end

    it "is not valid with same name and same user, false case sensitive for name" do
      user = create(:user)
      equipment_one = create(:equipment, user: user, name: "My fishing rod")
      equipment_two = build(:equipment, user: user, name: "my fishing ROD")
      expect(equipment_two).to_not be_valid
    end

    it "is valid with same name but different users" do
      user_one = create(:user)
      user_two = create(:user)
      equipment_one = create(:equipment, user: user_one)
      equipment_two = build(:equipment, user: user_two, name: equipment_one.name)
      expect(equipment_two).to be_valid
    end
  end
end
