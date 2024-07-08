class AddPublishedAtToNewsStories < ActiveRecord::Migration[7.1]
  def change
    add_column :news_stories, :published_at, :datetime
  end
end
