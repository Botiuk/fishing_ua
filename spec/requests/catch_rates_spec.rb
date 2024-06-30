require 'rails_helper'

RSpec.describe "CatchRates", type: :request do
  describe "non registered user management" do
    it "can GET index" do
      get catch_rates_path
      expect(response).to be_successful
    end

    it "cannot GET new and redirects to the sign_in page" do
      get new_catch_rate_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot GET edit and redirects to the sign_in page" do
      catch_rate = create(:catch_rate)
      get edit_catch_rate_path(catch_rate)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot DELETE destroy and redirects to the sign_in page" do
      catch_rate = create(:catch_rate)
      delete catch_rate_path(catch_rate)
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
      get catch_rates_path
      expect(response).to be_successful
    end

    it "cannot GET new and redirects to the root page" do
      get new_catch_rate_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET edit and redirects to the root page" do
      catch_rate = create(:catch_rate)
      get edit_catch_rate_path(catch_rate)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot DELETE destroy and redirects to root page" do
      catch_rate = create(:catch_rate)
      delete catch_rate_path(catch_rate)
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
      get catch_rates_path
      expect(response).to be_successful
    end

    it "cannot GET new and redirects to the root page" do
      get new_catch_rate_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET edit and redirects to the root page" do
      catch_rate = create(:catch_rate)
      get edit_catch_rate_path(catch_rate)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot DELETE destroy and redirects to root page" do
      catch_rate = create(:catch_rate)
      delete catch_rate_path(catch_rate)
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
      get catch_rates_path
      expect(response).to be_successful
    end

    it "can GET new" do
      get new_catch_rate_path
      expect(response).to be_successful
    end

    it "can POST create" do
      water_bioresource = create(:water_bioresource)
      post catch_rates_path, params: { catch_rate: attributes_for(:catch_rate, water_bioresource_id: water_bioresource.id) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.catch_rate'))
    end

    it "can GET edit" do
      catch_rate = create(:catch_rate)
      get edit_catch_rate_path(catch_rate)
      expect(response).to be_successful
    end

    it "can PUT update" do
      catch_rate = create(:catch_rate, length_dnipro: 11.1)
      put catch_rate_path(catch_rate), params: { catch_rate: {length_dnipro: 22.2} }
      expect(catch_rate.reload.length_dnipro).to eq(22.2)
      expect(response).to redirect_to(catch_rates_url)
      expect(flash[:notice]).to include(I18n.t('notice.update.catch_rate'))
    end

    it "can DELETE destroy" do
      catch_rate = create(:catch_rate)
      delete catch_rate_path(catch_rate)
      expect(response).to redirect_to(catch_rates_url)
      expect(flash[:notice]).to include(I18n.t('notice.destroy.catch_rate'))
    end
  end
end
