require 'rails_helper'

RSpec.describe Tool, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      tool = build(:tool)
      expect(tool).to be_valid
    end

    it "is not valid without a name" do
      tool = build(:tool, name: nil)
      expect(tool).to_not be_valid
    end

    it "is valid without a description" do
      tool = build(:tool, description: nil)
      expect(tool).to be_valid
    end

    it "is not valid with same name and same user" do
      user = create(:user)
      tool_one = create(:tool, user: user)
      tool_two = build(:tool, user: user, name: tool_one.name)
      expect(tool_two).to_not be_valid
    end

    it "is not valid with same name and same user, false case sensitive for name" do
      user = create(:user)
      tool_one = create(:tool, user: user, name: "My fishing rod")
      tool_two = build(:tool, user: user, name: "my fishing ROD")
      expect(tool_two).to_not be_valid
    end

    it "is valid with same name but different users" do
      user_one = create(:user)
      user_two = create(:user)
      tool_one = create(:tool, user: user_one)
      tool_two = build(:tool, user: user_two, name: tool_one.name)
      expect(tool_two).to be_valid
    end
  end
end
