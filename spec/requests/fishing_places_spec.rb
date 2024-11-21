# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'FishingPlaces' do
  describe 'non registered user management' do
    it 'cannot GET index' do
      get fishing_places_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it 'cannot GET new and redirects to the sign_in page' do
      get new_fishing_place_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it 'cannot GET edit and redirects to the sign_in page' do
      fishing_place = create(:fishing_place)
      get edit_fishing_place_path(fishing_place)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it 'cannot GET statistic' do
      fishing_place = create(:fishing_place)
      get fishing_places_statistic_path(id: fishing_place.id)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end
  end

  describe 'registered user management' do
    let(:test_user) { create(:user) }

    before do
      login_as(test_user, scope: :user)
    end

    it 'can GET index' do
      get fishing_places_path
      expect(response).to be_successful
    end

    it 'can GET new' do
      get new_fishing_place_path
      expect(response).to be_successful
    end

    it 'can POST create' do
      post fishing_places_path, params: { fishing_place: attributes_for(:fishing_place) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.fishing_place'))
    end

    it 'can GET edit' do
      fishing_place = create(:fishing_place, user_id: test_user.id)
      get edit_fishing_place_path(fishing_place)
      expect(response).to be_successful
    end

    it 'cannot GET edit fishing_place with other user_id' do
      fishing_place = create(:fishing_place)
      get edit_fishing_place_path(fishing_place)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'can PUT update' do
      fishing_place = create(:fishing_place, user_id: test_user.id, name: 'My lake')
      put fishing_place_path(fishing_place), params: { fishing_place: { name: 'My river' } }
      expect(fishing_place.reload.name).to eq('My river')
      expect(response).to redirect_to(fishing_places_url)
      expect(flash[:notice]).to include(I18n.t('notice.update.fishing_place'))
    end

    it 'can GET statistic' do
      fishing_place = create(:fishing_place, user_id: test_user.id)
      get fishing_places_statistic_path(id: fishing_place.id)
      expect(response).to be_successful
    end

    it 'cannot GET statistic for fishing_place with other user_id' do
      fishing_place = create(:fishing_place)
      get fishing_places_statistic_path(id: fishing_place.id)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end
end
