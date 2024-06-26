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

    it "cannot GET statistic" do
      tool = create(:tool)
      get tools_statistic_path(id: tool.id)
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
      get tools_path
      expect(response).to be_successful
    end

    it "can GET new" do
      get new_tool_path
      expect(response).to be_successful
    end

    it "can POST create, tool_type equipment" do
      post tools_path, params: { tool: attributes_for(:tool, tool_type: "equipment") }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.equipment'))
    end

    it "can POST create, tool_type bait" do
      post tools_path, params: { tool: attributes_for(:tool, tool_type: "bait") }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.bait'))
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

    it "can PUT update, tool_type equipment" do
      tool = create(:tool, user_id: @user.id, name: "My rod", tool_type: "equipment")
      put tool_path(tool), params: { tool: {name: "My pod"} }
      expect(tool.reload.name).to eq("My pod")
      expect(response).to redirect_to(tools_url(tool_type: "equipment"))
      expect(flash[:notice]).to include(I18n.t('notice.update.equipment'))
    end

    it "can PUT update, tool_type bait" do
      tool = create(:tool, user_id: @user.id, name: "My rod", tool_type: "bait")
      put tool_path(tool), params: { tool: {name: "My pod"} }
      expect(tool.reload.name).to eq("My pod")
      expect(response).to redirect_to(tools_url(tool_type: "bait"))
      expect(flash[:notice]).to include(I18n.t('notice.update.bait'))
    end

    it "can DELETE destroy, tool_type equipment" do
      tool = create(:tool, user_id: @user.id, tool_type: "equipment")
      delete tool_path(tool)
      expect(response).to redirect_to(tools_url(tool_type: "equipment"))
      expect(flash[:notice]).to include(I18n.t('notice.destroy.equipment'))
    end

    it "can DELETE destroy, tool_type bait" do
      tool = create(:tool, user_id: @user.id, tool_type: "bait")
      delete tool_path(tool)
      expect(response).to redirect_to(tools_url(tool_type: "bait"))
      expect(flash[:notice]).to include(I18n.t('notice.destroy.bait'))
    end

    it "cannot DELETE destroy tool with other user_id" do
      tool = create(:tool)
      delete tool_path(tool)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "can GET statistic" do
      tool = create(:tool, user_id: @user.id)
      get tools_statistic_path(id: tool.id)
      expect(response).to be_successful
    end

    it "cannot GET statistic for tool with other user_id" do
      tool = create(:tool)
      get tools_statistic_path(id: tool.id)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end
  end
end
