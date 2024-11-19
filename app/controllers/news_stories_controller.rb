# frozen_string_literal: true

class NewsStoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_news_story, only: %i[edit update show destroy]
  authorize_resource

  def index
    if user_signed_in? && current_user.role != 'user'
      @pagy, @news_stories = pagy(NewsStory.order(published_at: :desc), items: 9)
    else
      @pagy, @news_stories = pagy(
        NewsStory.where.not(published_at: nil).where.not('published_at > ?',
                                                         DateTime.now).order(published_at: :desc), items: 9
      )
    end
  rescue Pagy::OverflowError
    redirect_to news_stories_url(page: 1)
  end

  def show; end

  def new
    @news_story = NewsStory.new
  end

  def edit; end

  def create
    @news_story = NewsStory.new(news_story_params)
    @news_story.user_id = current_user.id
    if @news_story.save
      redirect_to news_story_url(@news_story), notice: t('notice.create.news_story')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @news_story.update(news_story_params)
      redirect_to news_story_url(@news_story), notice: t('notice.update.news_story')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @news_story.destroy
    redirect_to news_stories_url, notice: t('notice.destroy.news_story')
  end

  private

  def set_news_story
    @news_story = NewsStory.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to news_stories_url
  end

  def news_story_params
    params.require(:news_story).permit(:title, :published_at, :cover, :content)
  end
end
