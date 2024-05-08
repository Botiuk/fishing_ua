require 'rails_helper'

RSpec.describe "WaterBioresources", type: :request do
  before :each do
    user = create(:user, role: "admin")
    login_as(user, :scope => :user)
  end

  it "GET index" do
    get water_bioresources_path
    expect(response).to be_successful
  end

  it "GET new" do
    get new_water_bioresource_path
    expect(response).to be_successful
  end

  it "POST create" do
    post water_bioresources_path, params: { water_bioresource: attributes_for(:water_bioresource) }
    expect(response).to be_redirect
    follow_redirect!
    expect(flash[:notice]).to include(I18n.t('notice.create.water_bioresource'))
  end

  it "GET edit" do
    water_bioresource = create(:water_bioresource)
    get edit_water_bioresource_path(water_bioresource)
    expect(response).to be_successful
  end

  it "PUT update" do
    water_bioresource = create(:water_bioresource, name: "Abcd")
    put water_bioresource_path(water_bioresource), params: { water_bioresource: {name: "Dbca"} }
    expect(water_bioresource.reload.name).to eq("Dbca")
    expect(response).to redirect_to(water_bioresources_url)
    expect(flash[:notice]).to include(I18n.t('notice.update.water_bioresource'))
  end
end
