class DropMaterializedViews < ActiveRecord::Migration[5.0]
  def change
    drop_view :impressions_by_stream_by_day, revert_to_version: 2, materialized: true
    drop_view :impressions_by_logged_in_and_out_by_days, revert_to_version: 1, materialized: true
    drop_view :impressions_by_email_by_days, revert_to_version: 1, materialized: true
    drop_view :impressions_by_days, revert_to_version: 1, materialized: true
    drop_view :impressions_by_category_by_days, revert_to_version: 1, materialized: true
  end
end
