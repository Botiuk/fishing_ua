require 'rails_helper'

RSpec.describe WaterBioresource, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      water_bioresource = build(:water_bioresource)
      expect(water_bioresource).to be_valid
    end

    it "is not valid without a name" do
      water_bioresource = build(:water_bioresource, name: nil)
      expect(water_bioresource).to_not be_valid
    end

    it "is not valid without a latin_name" do
      water_bioresource = build(:water_bioresource, latin_name: nil)
      expect(water_bioresource).to_not be_valid
    end

    it "is not valid with not unique name" do
      water_bioresource_one = create(:water_bioresource)
      water_bioresource_two = build(:water_bioresource, name: water_bioresource_one.name)
      expect(water_bioresource_two).to_not be_valid
    end

    it "is not valid with not unique name, false case sensitive " do
      water_bioresource_one = create(:water_bioresource, name: "Abc123")
      water_bioresource_two = build(:water_bioresource, name: "ABC123")
      expect(water_bioresource_two).to_not be_valid
    end

    it "is not valid with not unique latin_name" do
      water_bioresource_one = create(:water_bioresource)
      water_bioresource_two = build(:water_bioresource, latin_name: water_bioresource_one.latin_name)
      expect(water_bioresource_two).to_not be_valid
    end

    it "is not valid with not unique latin_name, false case sensitive " do
      water_bioresource_one = create(:water_bioresource, latin_name: "Abc123")
      water_bioresource_two = build(:water_bioresource, latin_name: "ABC123")
      expect(water_bioresource_two).to_not be_valid
    end

    it "is not valid with a small first letter in name" do
      water_bioresource = build(:water_bioresource, name: "salmon")
      expect(water_bioresource).to_not be_valid
    end

    it "is not valid with a small first letter in latin_name" do
      water_bioresource = build(:water_bioresource, latin_name: "salmon")
      expect(water_bioresource).to_not be_valid
    end
  end
end
