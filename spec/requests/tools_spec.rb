require 'rails_helper'

RSpec.describe "Tools", type: :request do
  describe "non registered user management" do
    it "cannot GET index" do
      get tools_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot GET new and redirects to the sign_in page" do
      get new_tool_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot GET edit and redirects to the sign_in page" do
      tool = create(:tool)
      get edit_tool_path(tool)
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end
  end

  describe "user-user management" do
    before :each do
      @user = create(:user)
      login_as(@user, :scope => :user)
    end

    it "can GET index" do
      get tools_path
      expect(response).to be_successful
    end

    it "can GET new" do
      get new_tool_path
      expect(response).to be_successful
    end

    it "can POST create" do
      post tools_path, params: { tool: attributes_for(:tool) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.tool'))
    end

    it "can GET edit" do
      tool = create(:tool, user_id: @user.id)
      get edit_tool_path(tool)
      expect(response).to be_successful
    end

    it "cannot GET edit tool with other user_id" do
      tool = create(:tool)
      get edit_tool_path(tool)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "can PUT update" do
      tool = create(:tool, user_id: @user.id, name: "My rod")
      put tool_path(tool), params: { tool: {name: "My pod"} }
      expect(tool.reload.name).to eq("My pod")
      expect(response).to redirect_to(tools_url)
      expect(flash[:notice]).to include(I18n.t('notice.update.tool'))
    end

    it "can DELETE destroy" do
      tool = create(:tool, user_id: @user.id)
      delete tool_path(tool)
      expect(response).to redirect_to(tools_url)
      expect(flash[:notice]).to include(I18n.t('notice.destroy.tool'))
    end

    it "cannot DELETE destroy tool with other user_id" do
      tool = create(:tool)
      delete tool_path(tool)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end

  describe "user-staff management" do
    before :each do
      @user = create(:user, role: "staff")
      login_as(@user, :scope => :user)
    end

    it "can GET index" do
      get tools_path
      expect(response).to be_successful
    end

    it "can GET new" do
      get new_tool_path
      expect(response).to be_successful
    end

    it "can POST create" do
      post tools_path, params: { tool: attributes_for(:tool) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.tool'))
    end

    it "can GET edit" do
      tool = create(:tool, user_id: @user.id)
      get edit_tool_path(tool)
      expect(response).to be_successful
    end

    it "cannot GET edit tool with other user_id" do
      tool = create(:tool)
      get edit_tool_path(tool)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "can PUT update" do
      tool = create(:tool, user_id: @user.id, name: "My rod")
      put tool_path(tool), params: { tool: {name: "My pod"} }
      expect(tool.reload.name).to eq("My pod")
      expect(response).to redirect_to(tools_url)
      expect(flash[:notice]).to include(I18n.t('notice.update.tool'))
    end

    it "can DELETE destroy" do
      tool = create(:tool, user_id: @user.id)
      delete tool_path(tool)
      expect(response).to redirect_to(tools_url)
      expect(flash[:notice]).to include(I18n.t('notice.destroy.tool'))
    end

    it "cannot DELETE destroy tool with other user_id" do
      tool = create(:tool)
      delete tool_path(tool)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end

  describe "user-admin management" do
    before :each do
      @user = create(:user, role: "admin")
      login_as(@user, :scope => :user)
    end

    it "can GET index" do
      get tools_path
      expect(response).to be_successful
    end

    it "can GET new" do
      get new_tool_path
      expect(response).to be_successful
    end

    it "can POST create" do
      post tools_path, params: { tool: attributes_for(:tool) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.tool'))
    end

    it "can GET edit" do
      tool = create(:tool, user_id: @user.id)
      get edit_tool_path(tool)
      expect(response).to be_successful
    end

    it "cannot GET edit tool with other user_id" do
      tool = create(:tool)
      get edit_tool_path(tool)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "can PUT update" do
      tool = create(:tool, user_id: @user.id, name: "My rod")
      put tool_path(tool), params: { tool: {name: "My pod"} }
      expect(tool.reload.name).to eq("My pod")
      expect(response).to redirect_to(tools_url)
      expect(flash[:notice]).to include(I18n.t('notice.update.tool'))
    end

    it "can DELETE destroy" do
      tool = create(:tool, user_id: @user.id)
      delete tool_path(tool)
      expect(response).to redirect_to(tools_url)
      expect(flash[:notice]).to include(I18n.t('notice.destroy.tool'))
    end

    it "cannot DELETE destroy tool with other user_id" do
      tool = create(:tool)
      delete tool_path(tool)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end
end
