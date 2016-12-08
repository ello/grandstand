class CreateImpressionsByDays < ActiveRecord::Migration
  def change
    create_view :impressions_by_days, materialized: true
    add_index :impressions_by_days, :day, unique: true
  end
end
