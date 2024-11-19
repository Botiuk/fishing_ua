# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatchRate do
  describe 'validations' do
    it 'is valid with valid attributes' do
      catch_rate = build(:catch_rate)
      expect(catch_rate).to be_valid
    end

    it 'is not valid without a water_bioresource' do
      catch_rate = build(:catch_rate, water_bioresource: nil)
      expect(catch_rate).not_to be_valid
    end

    it 'is valid without a length_dnipro' do
      catch_rate = build(:catch_rate, length_dnipro: nil)
      expect(catch_rate).to be_valid
    end

    it 'is valid without a length_other' do
      catch_rate = build(:catch_rate, length_other: nil)
      expect(catch_rate).to be_valid
    end

    it 'is valid without a length_black' do
      catch_rate = build(:catch_rate, length_black: nil)
      expect(catch_rate).to be_valid
    end

    it 'is valid without a length_azov' do
      catch_rate = build(:catch_rate, length_azov: nil)
      expect(catch_rate).to be_valid
    end

    it 'is not valid with same water_bioresource' do
      water_bioresource = create(:water_bioresource)
      catch_rate_one = create(:catch_rate, water_bioresource: water_bioresource)
      catch_rate_two = build(:catch_rate, water_bioresource: catch_rate_one.water_bioresource)
      expect(catch_rate_two).not_to be_valid
    end

    it 'is not valid when a length_dnipro is less than 0' do
      catch_rate = build(:catch_rate, length_dnipro: -0.1)
      expect(catch_rate).not_to be_valid
    end

    it 'is not valid when a length_dnipro is not number' do
      catch_rate = build(:catch_rate, length_dnipro: 'Ten')
      expect(catch_rate).not_to be_valid
    end

    it 'is valid when a length_dnipro is integer' do
      catch_rate = build(:catch_rate, length_dnipro: 42)
      expect(catch_rate).to be_valid
    end

    it 'is not valid when a length_other is less than 0' do
      catch_rate = build(:catch_rate, length_other: -0.1)
      expect(catch_rate).not_to be_valid
    end

    it 'is not valid when a length_other is not number' do
      catch_rate = build(:catch_rate, length_other: 'Ten')
      expect(catch_rate).not_to be_valid
    end

    it 'is valid when a length_other is integer' do
      catch_rate = build(:catch_rate, length_other: 42)
      expect(catch_rate).to be_valid
    end

    it 'is not valid when a length_black is less than 0' do
      catch_rate = build(:catch_rate, length_black: -0.1)
      expect(catch_rate).not_to be_valid
    end

    it 'is not valid when a length_black is not number' do
      catch_rate = build(:catch_rate, length_black: 'Ten')
      expect(catch_rate).not_to be_valid
    end

    it 'is valid when a length_black is integer' do
      catch_rate = build(:catch_rate, length_black: 42)
      expect(catch_rate).to be_valid
    end

    it 'is not valid when a length_azov is less than 0' do
      catch_rate = build(:catch_rate, length_azov: -0.1)
      expect(catch_rate).not_to be_valid
    end

    it 'is not valid when a length_azov is not number' do
      catch_rate = build(:catch_rate, length_azov: 'Ten')
      expect(catch_rate).not_to be_valid
    end

    it 'is valid when a length_azov is integer' do
      catch_rate = build(:catch_rate, length_azov: 42)
      expect(catch_rate).to be_valid
    end
  end
end
