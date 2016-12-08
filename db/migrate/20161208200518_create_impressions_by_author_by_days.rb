class CreateImpressionsByAuthorByDays < ActiveRecord::Migration
  def change
    create_view :impressions_by_author_by_days, materialized: true
    add_index :impressions_by_author_by_days, [:author_id, :day], unique: true
  end
end
