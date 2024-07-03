require 'rails_helper'

RSpec.describe NewsStory, type: :model do
  it "is valid with valid attributes" do
    news_story = build(:news_story)
    expect(news_story).to be_valid
  end

  it "is not valid without a catch_amount" do
    news_story = build(:news_story, title: nil)
    expect(news_story).to_not be_valid
  end

  it "is not valid with a small first letter in title" do
    news_story = build(:news_story, title: "firs news")
    expect(news_story).to_not be_valid
  end
end
