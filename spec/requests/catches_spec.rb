require 'rails_helper'

RSpec.describe "Catches", type: :request do
  describe "non registered user management" do
    it "cannot GET index" do
      get catches_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot GET new and redirects to the sign_in page" do
      get new_catch_path
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
      get catches_path
      expect(response).to be_successful
    end

    it "can GET new with params fishing_session_id, when session active" do
      fishing_session = create(:fishing_session, user_id: @user.id, start_at: DateTime.now, end_at: nil)
      get new_catch_path(fishing_session_id: fishing_session.id)
      expect(response).to be_successful
    end

    it "cannot GET new with params fishing_session_id, when session close, redirect_to fishing session" do
      fishing_session = create(:fishing_session, user_id: @user.id)
      get new_catch_path(fishing_session_id: fishing_session.id)
      expect(response).to redirect_to(fishing_session_path(fishing_session))
      expect(flash[:alert]).to include I18n.t('alert.fishing_session_close')
    end

    it "can GET new without params fishing_session_id, when session active" do
      fishing_session = create(:fishing_session, user_id: @user.id, start_at: DateTime.now, end_at: nil)
      get new_catch_path
      expect(response).to be_successful
    end

    it "cannot GET new without params fishing_session_id, when session close, redirect_to new fishing session" do
      fishing_session = create(:fishing_session, user_id: @user.id)
      get new_catch_path
      expect(response).to redirect_to(new_fishing_session_path)
      expect(flash[:alert]).to include I18n.t('alert.new.session_catch')
    end

    it "can POST create when catch_result pick_up and catch_length >= rate_length, day_rate present and == 0" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      day_rate = create(:day_rate, catch_amount: 0, water_bioresource_id: water_bioresource.id)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_time: DateTime.now) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.catch_pick'))
    end 

    it "can POST create when catch_result pick_up and catch_length >= rate_length, day_rate present, amount type weight, all_day_resource weight + catch weight <= day_rate" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      day_rate = create(:day_rate, catch_amount: 1.5, amount_type: "weight", water_bioresource_id: water_bioresource.id)
      catch_one = create(:catch, fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_result: "pick_up", catch_time: DateTime.now, catch_weight: 1.0 )
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_time: DateTime.now, catch_weight: 0.5) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.catch_pick'))
    end 
   
    it "cannot POST create when catch_result pick_up and catch_length >= rate_length, day_rate present, amount type weight, all_day_resource weight + catch weight > day_rate" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      day_rate = create(:day_rate, catch_amount: 1.5, amount_type: "weight", water_bioresource_id: water_bioresource.id)
      catch_one = create(:catch, fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_result: "pick_up", catch_time: DateTime.now, catch_weight: 1.2 )
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_time: DateTime.now, catch_weight: 0.5) }
      expect(flash.now[:alert]).to include(I18n.t('alert.create.catch.day_weight_one_resource'))
      expect(response).to have_http_status(422)
    end

    it "cannot POST create when catch_result pick_up and catch_length >= rate_length, day_rate present, amount type weight, catch weight == 0" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      day_rate = create(:day_rate, catch_amount: 1.5, amount_type: "weight", water_bioresource_id: water_bioresource.id)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_time: DateTime.now, catch_weight: 0) }
      expect(flash.now[:alert]).to include(I18n.t('alert.create.catch.catch_weight'))
      expect(response).to have_http_status(422)
    end

    it "can POST create when catch_result pick_up and catch_length >= rate_length, day_rate present, amount type quantity, all_day_resource quantity >= day_rate" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      day_rate = create(:day_rate, catch_amount: 1.0, amount_type: "quantity", water_bioresource_id: water_bioresource.id)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_time: DateTime.now) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.catch_pick'))
    end

    it "cannot POST create when catch_result pick_up and catch_length >= rate_length, day_rate present, amount type quantity, all_day_resource quantity < day_rate" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      day_rate = create(:day_rate, catch_amount: 1.0, amount_type: "quantity", water_bioresource_id: water_bioresource.id)
      catch_one = create(:catch, fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_result: "pick_up", catch_time: DateTime.now)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_time: DateTime.now) }
      expect(flash.now[:alert]).to include(I18n.t('alert.create.catch.day_quantity_one_resource'))
      expect(response).to have_http_status(422)
    end

    it "can POST create when catch_result pick_up and catch_length >= rate_length, day_rate absent, catch weight <= max and (day_weight - max + catch) <= 3" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      catch_one = create(:catch, fishing_session_id: fishing_session.id, catch_result: "pick_up", catch_weight: 5.0, catch_time: DateTime.now)
      catch_two = create(:catch, fishing_session_id: fishing_session.id, catch_result: "pick_up", catch_weight: 0.5, catch_time: DateTime.now)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_weight: 2.0, catch_time: DateTime.now) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.catch_pick'))
    end

    it "can POST create when catch_result pick_up and catch_length >= rate_length, day_rate absent, catch weight >= max and day_weight <= 3" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      catch_one = create(:catch, fishing_session_id: fishing_session.id, catch_result: "pick_up", catch_weight: 2.0, catch_time: DateTime.now)
      catch_two = create(:catch, fishing_session_id: fishing_session.id, catch_result: "pick_up", catch_weight: 0.5, catch_time: DateTime.now)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_weight: 5.0, catch_time: DateTime.now) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.catch_pick'))
    end

    it "cannot POST create when catch_result pick_up and catch_length >= rate_length, day_rate absent, day weight more than 3 + max" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_one = create(:catch, fishing_session_id: fishing_session.id, catch_result: "pick_up", catch_weight: 2.0, catch_time: DateTime.now)
      catch_two = create(:catch, fishing_session_id: fishing_session.id, catch_result: "pick_up", catch_weight: 4.0, catch_time: DateTime.now)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_weight: 1.5, catch_time: DateTime.now) }
      expect(flash.now[:alert]).to include(I18n.t('alert.create.catch.day_weight'))
      expect(response).to have_http_status(422)
    end

    it "can POST create when catch_result pick_up and catch_length >= rate_length, day_rate absent, all_day_weight absent" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.catch_pick'))
    end

    it "cannot POST create when catch_result pick_up and catch_length >= rate_length, day_rate absent, catch weight == 0" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: catch_rate.length, catch_weight: 0, catch_time: DateTime.now) }
      expect(flash.now[:alert]).to include(I18n.t('alert.create.catch.catch_weight'))
      expect(response).to have_http_status(422)
    end

    it "cannot POST create when catch_result pick_up and catch_length < rate_length" do
      fishing_session = create(:fishing_session, user_id: @user.id, start_at: DateTime.now, end_at: nil)
      water_bioresource = create(:water_bioresource)
      catch_rate = create(:catch_rate, water_bioresource_id: water_bioresource.id, where_catch: fishing_session.fishing_place.where_catch)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id, catch_length: (catch_rate.length - 1)) }
      expect(flash.now[:alert]).to include(I18n.t('alert.create.catch.length_rate'))
      expect(response).to have_http_status(422)
    end

    it "cannot POST create when catch_result pick_up and rate length not present" do
      fishing_session = create(:fishing_session, user_id: @user.id, start_at: DateTime.now, end_at: nil)
      water_bioresource = create(:water_bioresource)
      post catches_path, params: { catch: attributes_for(:catch, catch_result: "pick_up", fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id) }
      expect(flash.now[:alert]).to include(I18n.t('alert.create.catch.forbiden'))
      expect(response).to have_http_status(422)
    end

    it "can POST create when catch_result set_free" do
      fishing_session = create(:fishing_session, user_id: @user.id, start_at: DateTime.now, end_at: nil)
      water_bioresource = create(:water_bioresource)
      post catches_path, params: { catch: attributes_for(:catch, fishing_session_id: fishing_session.id, water_bioresource_id: water_bioresource.id) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.catch_free'))
    end

    it "can GET show" do
      fishing_session = create(:fishing_session, user_id: @user.id)
      catch = create(:catch, fishing_session_id: fishing_session.id)
      get catch_path(catch)
      expect(response).to be_successful
    end

    it "cannot GET show other user catch" do
      fishing_session = create(:fishing_session)
      catch = create(:catch, fishing_session_id: fishing_session.id)
      get catch_path(catch)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "can PUT update" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      catch = create(:catch, fishing_session_id: fishing_session.id, catch_result: "pick_up")
      put catch_path(catch), params: { catch: {catch_result: "set_free"} }
      expect(catch.reload.catch_result).to eq("set_free")
      expect(response).to redirect_to(catch_path(catch))
      expect(flash[:notice]).to include(I18n.t('notice.update.catch'))
    end
  end
end
