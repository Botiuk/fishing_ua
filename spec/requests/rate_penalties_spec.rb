# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RatePenalties' do
  describe 'non registered user management' do
    it 'can GET index' do
      get rate_penalties_path
      expect(response).to be_successful
    end

    it 'cannot GET new and redirects to the sign_in page' do
      get new_rate_penalty_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it 'cannot GET edit and redirects to the sign_in page' do
      rate_penalty = create(:rate_penalty)
      get edit_rate_penalty_path(rate_penalty)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it 'cannot DELETE destroy and redirects to the sign_in page' do
      rate_penalty = create(:rate_penalty)
      delete rate_penalty_path(rate_penalty)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end
  end

  describe 'user-user management' do
    before do
      user = create(:user)
      login_as(user, scope: :user)
    end

    it 'can GET index' do
      get rate_penalties_path
      expect(response).to be_successful
    end

    it 'cannot GET new and redirects to the root page' do
      get new_rate_penalty_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'cannot GET edit and redirects to the root page' do
      rate_penalty = create(:rate_penalty)
      get edit_rate_penalty_path(rate_penalty)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'cannot DELETE destroy and redirects to root page' do
      rate_penalty = create(:rate_penalty)
      delete rate_penalty_path(rate_penalty)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end

  describe 'user-staff management' do
    before do
      user = create(:user, role: 'staff')
      login_as(user, scope: :user)
    end

    it 'can GET index' do
      get rate_penalties_path
      expect(response).to be_successful
    end

    it 'cannot GET new and redirects to the root page' do
      get new_rate_penalty_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'cannot GET edit and redirects to the root page' do
      rate_penalty = create(:rate_penalty)
      get edit_rate_penalty_path(rate_penalty)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'cannot DELETE destroy and redirects to root page' do
      rate_penalty = create(:rate_penalty)
      delete rate_penalty_path(rate_penalty)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end

  describe 'user-admin management' do
    before do
      user = create(:user, role: 'admin')
      login_as(user, scope: :user)
    end

    it 'can GET index' do
      get rate_penalties_path
      expect(response).to be_successful
    end

    it 'can GET new' do
      get new_rate_penalty_path
      expect(response).to be_successful
    end

    it 'can POST create' do
      w_bio = create(:water_bioresource)
      post rate_penalties_path, params: { rate_penalty: attributes_for(:rate_penalty, water_bioresource_id: w_bio.id) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.rate_penalty'))
    end

    it 'can GET edit' do
      rate_penalty = create(:rate_penalty)
      get edit_rate_penalty_path(rate_penalty)
      expect(response).to be_successful
    end

    it 'can PUT update' do
      rate_penalty = create(:rate_penalty, money: 12_345)
      put rate_penalty_path(rate_penalty), params: { rate_penalty: { money: 54_321 } }
      expect(rate_penalty.reload.money).to eq(54_321)
      expect(response).to redirect_to(rate_penalties_url)
      expect(flash[:notice]).to include(I18n.t('notice.update.rate_penalty'))
    end

    it 'can DELETE destroy' do
      rate_penalty = create(:rate_penalty)
      delete rate_penalty_path(rate_penalty)
      expect(response).to redirect_to(rate_penalties_url)
      expect(flash[:notice]).to include(I18n.t('notice.destroy.rate_penalty'))
    end
  end
end
