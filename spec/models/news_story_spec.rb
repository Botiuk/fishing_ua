# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsStory do
  it 'is valid with valid attributes' do
    news_story = build(:news_story)
    expect(news_story).to be_valid
  end

  it 'is not valid without a title' do
    news_story = build(:news_story, title: nil)
    expect(news_story).not_to be_valid
  end

  it 'is not valid without a user_id' do
    news_story = build(:news_story, user_id: nil)
    expect(news_story).not_to be_valid
  end

  it 'is valid without a published_at' do
    news_story = build(:news_story, published_at: nil)
    expect(news_story).to be_valid
  end

  it 'is not valid with a small first letter in title' do
    news_story = build(:news_story, title: 'firs news')
    expect(news_story).not_to be_valid
  end
end
