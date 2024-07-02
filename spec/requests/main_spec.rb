require 'rails_helper'

RSpec.describe "main", type: :request do
  describe "non registered user management" do
    it "can GET index" do
      get root_path
      expect(response).to be_successful
    end

    it "cannot GET statistic and redirects to the sign_in page" do
      get main_statistic_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end
  end

  describe "registered user management" do
    before :each do
      @user = create(:user)
      login_as(@user, :scope => :user)
    end

    it "can GET index" do
      get root_path
      expect(response).to be_successful
    end

    it "can GET statistic" do
      get main_statistic_path
      expect(response).to be_successful
    end
  end
end
