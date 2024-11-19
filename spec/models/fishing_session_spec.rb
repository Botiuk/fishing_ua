# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FishingSession do
  describe 'validations' do
    it 'is valid with valid attributes' do
      fishing_session = build(:fishing_session)
      expect(fishing_session).to be_valid
    end

    it 'is not valid without a start_at' do
      fishing_session = build(:fishing_session, start_at: nil)
      expect(fishing_session).not_to be_valid
    end

    it 'is valid without a end_at' do
      fishing_session = build(:fishing_session, end_at: nil)
      expect(fishing_session).to be_valid
    end

    it 'is not valid without a fishing_place' do
      fishing_session = build(:fishing_session, fishing_place: nil)
      expect(fishing_session).not_to be_valid
    end

    it 'is not valid when start_at greater than end_at' do
      time_now = DateTime.now
      fishing_session = build(:fishing_session, start_at: time_now, end_at: (time_now - 1.minute))
      expect(fishing_session).not_to be_valid
    end

    it 'is not valid when end_at equal start_at' do
      time_now = DateTime.now
      fishing_session = build(:fishing_session, start_at: time_now, end_at: time_now)
      expect(fishing_session).not_to be_valid
    end
  end
end
