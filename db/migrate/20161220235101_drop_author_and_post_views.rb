class DropAuthorAndPostViews < ActiveRecord::Migration[5.0]
  def change
    drop_view :impressions_by_author_by_days, materialized: true
    drop_view :impressions_by_post_by_days, materialized: true
  end
end
