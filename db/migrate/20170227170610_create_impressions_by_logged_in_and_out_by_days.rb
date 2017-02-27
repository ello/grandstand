class CreateImpressionsByLoggedInAndOutByDays < ActiveRecord::Migration[5.0]
  def change
    create_view :impressions_by_logged_in_and_out_by_days, materialized: true
    add_index :impressions_by_logged_in_and_out_by_days, :day, unique: true
  end
end
