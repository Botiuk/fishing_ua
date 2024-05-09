require 'rails_helper'

RSpec.describe "RatePenalties", type: :request do
  before :each do
    user = create(:user, role: "admin")
    login_as(user, :scope => :user)
  end

  it "GET index" do
    get rate_penalties_path
    expect(response).to be_successful
  end

  it "GET new" do
    get new_rate_penalty_path
    expect(response).to be_successful
  end

  it "POST create" do
    water_bioresource = create(:water_bioresource)
    post rate_penalties_path, params: { rate_penalty: attributes_for(:rate_penalty, water_bioresource_id: water_bioresource.id) }
    expect(response).to be_redirect
    follow_redirect!
    expect(flash[:notice]).to include(I18n.t('notice.create.rate_penalty'))
  end

  it "GET edit" do
    rate_penalty = create(:rate_penalty)
    get edit_rate_penalty_path(rate_penalty)
    expect(response).to be_successful
  end

  it "PUT update" do
    rate_penalty = create(:rate_penalty, money: 12345)
    put rate_penalty_path(rate_penalty), params: { rate_penalty: {money: 54321} }
    expect(rate_penalty.reload.money).to eq(54321)
    expect(response).to redirect_to(rate_penalties_url)
    expect(flash[:notice]).to include(I18n.t('notice.update.rate_penalty'))
  end

  it "DELETE destroy" do
    rate_penalty = create(:rate_penalty)
    delete rate_penalty_path(rate_penalty)
    expect(response).to redirect_to(rate_penalties_url)
    expect(flash[:notice]).to include(I18n.t('notice.destroy.rate_penalty'))
  end
end
