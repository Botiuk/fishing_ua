require 'rails_helper'

RSpec.describe ToolCatch, type: :model do
  it "is valid with valid attributes" do
    tool_catch = build(:tool_catch)
    expect(tool_catch).to be_valid
  end

  it "is not valid without a tool_id" do
    tool_catch = build(:tool_catch, tool_id: nil)
    expect(tool_catch).to_not be_valid
  end

  it "is not valid without a catch_id" do
    tool_catch = build(:tool_catch, catch_id: nil)
    expect(tool_catch).to_not be_valid
  end

  it "is not valid with same tool_id and same catch_id" do
    tool_catch_one = create(:tool_catch)
    tool_catch_two = build(:tool_catch, tool_id: tool_catch_one.tool_id, catch_id: tool_catch_one.catch_id)
    expect(tool_catch_two).to_not be_valid
  end
end
