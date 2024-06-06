require 'rails_helper'

RSpec.describe "DayRates", type: :request do
  describe "non registered user management" do
    it "can GET index" do
      get day_rates_path
      expect(response).to be_successful
    end

    it "cannot GET new and redirects to the sign_in page" do
      get new_day_rate_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot GET edit and redirects to the sign_in page" do
      day_rate = create(:day_rate)
      get edit_day_rate_path(day_rate)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot DELETE destroy and redirects to the sign_in page" do
      day_rate = create(:day_rate)
      delete day_rate_path(day_rate)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end
  end

  describe "user-user management" do
    before :each do
      user = create(:user)
      login_as(user, :scope => :user)
    end

    it "can GET index" do
      get day_rates_path
      expect(response).to be_successful
    end

    it "cannot GET new and redirects to the root page" do
      get new_day_rate_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET edit and redirects to the root page" do
      day_rate = create(:day_rate)
      get edit_day_rate_path(day_rate)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot DELETE destroy and redirects to root page" do
      day_rate = create(:day_rate)
      delete day_rate_path(day_rate)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end

  describe "user-staff management" do
    before :each do
      user = create(:user, role: "staff")
      login_as(user, :scope => :user)
    end

    it "can GET index" do
      get day_rates_path
      expect(response).to be_successful
    end

    it "cannot GET new and redirects to the root page" do
      get new_day_rate_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET edit and redirects to the root page" do
      day_rate = create(:day_rate)
      get edit_day_rate_path(day_rate)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot DELETE destroy and redirects to root page" do
      day_rate = create(:day_rate)
      delete day_rate_path(day_rate)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end

  describe "user-admin management" do
    before :each do
      user = create(:user, role: "admin")
      login_as(user, :scope => :user)
    end

    it "can GET index" do
      get day_rates_path
      expect(response).to be_successful
    end

    it "can GET new" do
      get new_day_rate_path
      expect(response).to be_successful
    end

    it "can POST create" do
      water_bioresource = create(:water_bioresource)
      post day_rates_path, params: { day_rate: attributes_for(:day_rate, water_bioresource_id: water_bioresource.id) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.day_rate'))
    end    

    it "can GET edit" do
      day_rate = create(:day_rate)
      get edit_day_rate_path(day_rate)
      expect(response).to be_successful
    end

    it "can PUT update" do
      day_rate = create(:day_rate, catch_amount: 12)
      put day_rate_path(day_rate), params: { day_rate: {catch_amount: 21.1} }
      expect(day_rate.reload.catch_amount).to eq(21.1)
      expect(response).to redirect_to(day_rates_url)
      expect(flash[:notice]).to include(I18n.t('notice.update.day_rate'))
    end

    it "can DELETE destroy" do
      day_rate = create(:day_rate)
      delete day_rate_path(day_rate)
      expect(response).to redirect_to(day_rates_url)
      expect(flash[:notice]).to include(I18n.t('notice.destroy.day_rate'))
    end
  end
end
