class CreateImpressionsByCategoryByDays < ActiveRecord::Migration[5.0]
  def change
    create_view :impressions_by_category_by_days, materialized: true
    add_index :impressions_by_category_by_days, [:category, :day], unique: true
  end
end
