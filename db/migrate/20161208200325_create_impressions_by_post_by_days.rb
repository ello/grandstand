class CreateImpressionsByPostByDays < ActiveRecord::Migration
  def change
    create_view :impressions_by_post_by_days, materialized: true
    add_index :impressions_by_post_by_days, [:post_id, :day], unique: true
  end
end
