require 'rails_helper'

RSpec.describe "NewsStories", type: :request do
  describe "non registered user management" do
    it "can GET index" do
      get news_stories_path
      expect(response).to be_successful
    end

    it "can GET show" do
      news_story = create(:news_story)
      get news_story_path(news_story)
      expect(response).to be_successful
    end

    it "cannot GET show if published_at == nil and  redirects to the root page" do
      news_story = create(:news_story, published_at: nil)
      get news_story_path(news_story)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET show if published_at > DateTime.now and  redirects to the root page" do
      news_story = create(:news_story, published_at: DateTime.now + 5.day)
      get news_story_path(news_story)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET new and redirects to the sign_in page" do
      get new_news_story_path
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to include I18n.t('devise.failure.unauthenticated')
    end

    it "cannot GET edit and redirects to the sign_in page" do
      news_story = create(:news_story)
      get edit_news_story_path(news_story)
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
      get news_stories_path
      expect(response).to be_successful
    end

    it "can GET show" do
      news_story = create(:news_story)
      get news_story_path(news_story)
      expect(response).to be_successful
    end

    it "cannot GET show if published_at == nil and redirects to the root page" do
      news_story = create(:news_story, published_at: nil)
      get news_story_path(news_story)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET show if published_at > DateTime.now and redirects to the root page" do
      news_story = create(:news_story, published_at: DateTime.now + 5.day)
      get news_story_path(news_story)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET new and redirects to the root page" do
      get new_news_story_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "cannot GET edit and redirects to the root page" do
      news_story = create(:news_story)
      get edit_news_story_path(news_story)
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
      get news_stories_path
      expect(response).to be_successful
    end

    it "can GET show" do
      news_story = create(:news_story)
      get news_story_path(news_story)
      expect(response).to be_successful
    end

    it "can GET show if published_at == nil" do
      news_story = create(:news_story, published_at: nil)
      get news_story_path(news_story)
      expect(response).to be_successful
    end

    it "can GET show if published_at > DateTime.now" do
      news_story = create(:news_story, published_at: DateTime.now + 5.day)
      get news_story_path(news_story)
      expect(response).to be_successful
    end

    it "can GET new" do
      get new_news_story_path
      expect(response).to be_successful
    end

    it "can POST create" do
      post news_stories_path, params: { news_story: attributes_for(:news_story, user_id: @user.id) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.news_story'))
    end

    it "can GET edit news_story with his user_id" do
      news_story = create(:news_story, user_id: @user.id)
      get edit_news_story_path(news_story)
      expect(response).to be_successful
    end

    it "cannot GET edit news_story with other user_id and redirects to the root page" do
      news_story = create(:news_story)
      get edit_news_story_path(news_story)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to include I18n.t('alert.access_denied')
    end

    it "can PUT update news_story with his user_id" do
      news_story = create(:news_story, title: "Abcd", user_id: @user.id)
      put news_story_path(news_story), params: { news_story: {title: "Dbca"} }
      expect(news_story.reload.title).to eq("Dbca")
      expect(response).to redirect_to(news_story_path(news_story))
      expect(flash[:notice]).to include(I18n.t('notice.update.news_story'))
    end

    it "can DELETE destroy news_story with his user_id" do
      news_story = create(:news_story, user_id: @user.id)
      delete news_story_path(news_story)
      expect(response).to redirect_to(news_stories_url)
      expect(flash[:notice]).to include(I18n.t('notice.destroy.news_story'))
    end
  end

  describe "user-admin management" do
    before :each do
      @user = create(:user, role: "admin")
      login_as(@user, :scope => :user)
    end

    it "can GET index" do
      get news_stories_path
      expect(response).to be_successful
    end

    it "can GET new" do
      get new_news_story_path
      expect(response).to be_successful
    end

    it "can POST create" do
      post news_stories_path, params: { news_story: attributes_for(:news_story, user_id: @user.id) }
      expect(response).to be_redirect
      follow_redirect!
      expect(flash[:notice]).to include(I18n.t('notice.create.news_story'))
    end

    it "can GET show" do
      news_story = create(:news_story)
      get news_story_path(news_story)
      expect(response).to be_successful
    end

    it "can GET show if published_at == nil" do
      news_story = create(:news_story, published_at: nil)
      get news_story_path(news_story)
      expect(response).to be_successful
    end

    it "can GET show if published_at > DateTime.now" do
      news_story = create(:news_story, published_at: DateTime.now + 5.day)
      get news_story_path(news_story)
      expect(response).to be_successful
    end

    it "can GET edit news_story with his user_id" do
      news_story = create(:news_story, user_id: @user.id)
      get edit_news_story_path(news_story)
      expect(response).to be_successful
    end

    it "can GET edit news_story with other user_id" do
      news_story = create(:news_story)
      get edit_news_story_path(news_story)
      expect(response).to be_successful
    end

    it "can PUT update news_story with his user_id" do
      news_story = create(:news_story, title: "Abcd", user_id: @user.id)
      put news_story_path(news_story), params: { news_story: {title: "Dbca"} }
      expect(news_story.reload.title).to eq("Dbca")
      expect(response).to redirect_to(news_story_path(news_story))
      expect(flash[:notice]).to include(I18n.t('notice.update.news_story'))
    end

    it "can PUT update news_story with other user_id" do
      news_story = create(:news_story, title: "Abcd")
      put news_story_path(news_story), params: { news_story: {title: "Dbca"} }
      expect(news_story.reload.title).to eq("Dbca")
      expect(response).to redirect_to(news_story_path(news_story))
      expect(flash[:notice]).to include(I18n.t('notice.update.news_story'))
    end

    it "can DELETE destroy news_story with his user_id" do
      news_story = create(:news_story, user_id: @user.id)
      delete news_story_path(news_story)
      expect(response).to redirect_to(news_stories_url)
      expect(flash[:notice]).to include(I18n.t('notice.destroy.news_story'))
    end

    it "can DELETE destroy news_story with other user_id" do
      news_story = create(:news_story)
      delete news_story_path(news_story)
      expect(response).to redirect_to(news_stories_url)
      expect(flash[:notice]).to include(I18n.t('notice.destroy.news_story'))
    end
  end
end
