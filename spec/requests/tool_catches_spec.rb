require 'rails_helper'

RSpec.describe "ToolCatches", type: :request do
  describe "non registered user management" do
    it "cannot GET new and redirects to the sign_in page" do
      get new_tool_catch_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot DELETE destroy and redirects to the sign_in page" do
      tool_catch = create(:tool_catch)
      delete tool_catch_path(tool_catch)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end
  end

  describe "registered user management" do
    before :each do
      @user = create(:user)
      login_as(@user, :scope => :user)
    end

    it "can GET new with params catch_id, tool_type" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      catch = create(:catch, fishing_session_id: fishing_session.id)
      tool = create(:tool, user_id: @user.id)
      get new_tool_catch_path(catch_id: catch.id, tool_type: tool.tool_type)
      expect(response).to be_successful
    end

    it "cannot GET new without params catch_id" do
      tool = create(:tool, user_id: @user.id)
      get new_tool_catch_path(tool_type: tool.tool_type)
      expect(response).to redirect_to(catches_url)
    end

    it "cannot GET new without params tool_type" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      catch = create(:catch, fishing_session_id: fishing_session.id)
      get new_tool_catch_path(catch_id: catch.id)
      expect(response).to redirect_to(catches_url)
    end

    it "can POST create when pair catch_id-tool_id unique, tool_type 'equipment'" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      catch = create(:catch, fishing_session_id: fishing_session.id)
      tool = create(:tool, user_id: @user.id, tool_type: "equipment")
      post tool_catches_path, params: { tool_catch: attributes_for(:tool_catch, catch_id: catch.id, tool_id: tool.id) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.tool_catch.equipment'))
    end

    it "can POST create when pair catch_id-tool_id unique, tool_type 'bait'" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      catch = create(:catch, fishing_session_id: fishing_session.id)
      tool = create(:tool, user_id: @user.id, tool_type: "bait")
      post tool_catches_path, params: { tool_catch: attributes_for(:tool_catch, catch_id: catch.id, tool_id: tool.id) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.tool_catch.bait'))
    end

    it "cannot POST create when pair catch_id-tool_id not unique" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      catch = create(:catch, fishing_session_id: fishing_session.id)
      tool = create(:tool, user_id: @user.id)
      tool_catch = create(:tool_catch, catch_id: catch.id, tool_id: tool.id)
      post tool_catches_path, params: { tool_catch: attributes_for(:tool_catch, catch_id: catch.id, tool_id: tool.id) }
      expect(response).to have_http_status(422)
    end

    it "can DELETE destroy his tool_catch, tool_type 'equipment'" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      catch = create(:catch, fishing_session_id: fishing_session.id)
      tool = create(:tool, user_id: @user.id, tool_type: "equipment")
      tool_catch = create(:tool_catch, catch_id: catch.id, tool_id: tool.id)
      delete tool_catch_path(tool_catch)
      expect(response).to redirect_to(catch_url(catch))
      expect(flash[:notice]).to include(I18n.t('notice.destroy.tool_catch.equipment'))
    end

    it "can DELETE destroy his tool_catch, tool_type 'bait'" do
      fishing_session = create(:fishing_session, user_id: @user.id, end_at: nil)
      catch = create(:catch, fishing_session_id: fishing_session.id)
      tool = create(:tool, user_id: @user.id, tool_type: "bait")
      tool_catch = create(:tool_catch, catch_id: catch.id, tool_id: tool.id)
      delete tool_catch_path(tool_catch)
      expect(response).to redirect_to(catch_url(catch))
      expect(flash[:notice]).to include(I18n.t('notice.destroy.tool_catch.bait'))
    end

    it "cannot DELETE destroy tool_catch of other user and redirects to root page" do
      tool_catch = create(:tool_catch)
      delete tool_catch_path(tool_catch)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end
end
