# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'WaterBioresources' do
  describe 'non registered user management' do
    it 'can GET index' do
      get water_bioresources_path
      expect(response).to be_successful
    end

    it 'can GET show' do
      water_bioresource = create(:water_bioresource)
      get water_bioresource_path(water_bioresource)
      expect(response).to be_successful
    end

    it 'cannot GET new and redirects to the sign_in page' do
      get new_water_bioresource_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it 'cannot GET edit and redirects to the sign_in page' do
      water_bioresource = create(:water_bioresource)
      get edit_water_bioresource_path(water_bioresource)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it 'cannot GET statistic' do
      water_bioresource = create(:water_bioresource)
      get water_bioresources_statistic_path(id: water_bioresource.id)
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
      get water_bioresources_path
      expect(response).to be_successful
    end

    it 'can GET show' do
      water_bioresource = create(:water_bioresource)
      get water_bioresource_path(water_bioresource)
      expect(response).to be_successful
    end

    it 'cannot GET new and redirects to the root page' do
      get new_water_bioresource_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'cannot GET edit and redirects to the root page' do
      water_bioresource = create(:water_bioresource)
      get edit_water_bioresource_path(water_bioresource)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'can GET statistic' do
      water_bioresource = create(:water_bioresource)
      get water_bioresources_statistic_path(id: water_bioresource.id)
      expect(response).to be_successful
    end
  end

  describe 'user-staff management' do
    before do
      user = create(:user, role: 'staff')
      login_as(user, scope: :user)
    end

    it 'can GET index' do
      get water_bioresources_path
      expect(response).to be_successful
    end

    it 'can GET show' do
      water_bioresource = create(:water_bioresource)
      get water_bioresource_path(water_bioresource)
      expect(response).to be_successful
    end

    it 'cannot GET new and redirects to the root page' do
      get new_water_bioresource_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'cannot GET edit and redirects to the root page' do
      water_bioresource = create(:water_bioresource)
      get edit_water_bioresource_path(water_bioresource)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it 'can GET statistic' do
      water_bioresource = create(:water_bioresource)
      get water_bioresources_statistic_path(id: water_bioresource.id)
      expect(response).to be_successful
    end
  end

  describe 'user-admin management' do
    before do
      user = create(:user, role: 'admin')
      login_as(user, scope: :user)
    end

    it 'can GET index' do
      get water_bioresources_path
      expect(response).to be_successful
    end

    it 'can GET new' do
      get new_water_bioresource_path
      expect(response).to be_successful
    end

    it 'can POST create' do
      post water_bioresources_path, params: { water_bioresource: attributes_for(:water_bioresource) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.water_bioresource'))
    end

    it 'can GET show' do
      water_bioresource = create(:water_bioresource)
      get water_bioresource_path(water_bioresource)
      expect(response).to be_successful
    end

    it 'can GET edit' do
      water_bioresource = create(:water_bioresource)
      get edit_water_bioresource_path(water_bioresource)
      expect(response).to be_successful
    end

    it 'can PUT update' do
      water_bioresource = create(:water_bioresource, name: 'Abcd')
      put water_bioresource_path(water_bioresource), params: { water_bioresource: { name: 'Dbca' } }
      expect(water_bioresource.reload.name).to eq('Dbca')
      expect(response).to redirect_to(water_bioresource_path(water_bioresource))
      expect(flash[:notice]).to include(I18n.t('notice.update.water_bioresource'))
    end

    it 'can GET statistic' do
      water_bioresource = create(:water_bioresource)
      get water_bioresources_statistic_path(id: water_bioresource.id)
      expect(response).to be_successful
    end
  end
end
