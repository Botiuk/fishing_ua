require 'rails_helper'

RSpec.describe "FishingSessions", type: :request do
  describe "non registered user management" do
    it "cannot GET index" do
      get fishing_sessions_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot GET new and redirects to the sign_in page" do
      get new_fishing_session_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot GET edit and redirects to the sign_in page" do
      fishing_session = create(:fishing_session)
      get edit_fishing_session_path(fishing_session)
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
      get fishing_sessions_path
      expect(response).to be_successful
    end

    it "can GET new" do
      get new_fishing_session_path
      expect(response).to be_successful
    end

    it "cannot GET new if his previous session did not end" do
      fishing_session = create(:fishing_session, user_id: @user.id, start_at: DateTime.now, end_at: nil)
      get new_fishing_session_path
      expect(response).to redirect_to(fishing_sessions_path)
      expect(flash[:alert]).to include I18n.t('alert.new.fishing_session')
    end

    it "can POST create" do
      fishing_place = create(:fishing_place, user_id: @user.id)
      post fishing_sessions_path, params: { fishing_session: attributes_for(:fishing_session, user_id: @user.id, fishing_place_id: fishing_place.id, end_at: nil) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.fishing_session'))
    end

    it "GET show" do
      fishing_session = create(:fishing_session, user_id: @user.id)
      get fishing_session_path(fishing_session)
      expect(response).to be_successful
    end

    it "can GET edit active fishing_session" do
      fishing_session = create(:fishing_session, end_at: nil, user_id: @user.id)
      get edit_fishing_session_path(fishing_session)
      expect(response).to be_successful
    end

    it "cannot GET edit fishing_session which ended" do
      fishing_session = create(:fishing_session, user_id: @user.id)
      get edit_fishing_session_path(fishing_session)
      expect(response).to redirect_to(fishing_session_path(fishing_session))
      expect(flash[:alert]).to include I18n.t('alert.fishing_session_close')
    end

    it "cannot GET edit active fishing_session with other user_id" do
      fishing_session = create(:fishing_session, end_at: nil)
      get edit_fishing_session_path(fishing_session)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET edit fishing_session with other user_id which ended" do
      fishing_session = create(:fishing_session)
      get edit_fishing_session_path(fishing_session)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "can PUT update when params[:end_at].nil" do
      fishing_place_one = create(:fishing_place, user_id: @user.id)
      fishing_place_two = create(:fishing_place, user_id: @user.id)
      fishing_session = create(:fishing_session, user_id: @user.id, fishing_place_id: fishing_place_one.id, end_at: nil)
      put fishing_session_path(fishing_session), params: { fishing_session: {fishing_place_id: fishing_place_two.id} }
      expect(fishing_session.reload.fishing_place_id).to eq(fishing_place_two.id)
      expect(response).to redirect_to(fishing_session_path(fishing_session))
      expect(flash[:notice]).to include(I18n.t('notice.update.fishing_session'))
    end

    it "can PUT update with params[:end_at]" do
      time = DateTime.now.strftime("%F %T")
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      put fishing_session_path(fishing_session), params: { fishing_session: {end_at: time} }
      expect(fishing_session.reload.end_at.strftime("%F %T")).to eq(time)
      expect(response).to redirect_to(fishing_session_path(fishing_session))
      expect(flash[:notice]).to include(I18n.t('notice.update.fishing_session_close'))
    end
  end
end
