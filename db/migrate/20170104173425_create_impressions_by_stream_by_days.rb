class CreateImpressionsByStreamByDays < ActiveRecord::Migration
  def change
    create_view :impressions_by_stream_by_day, materialized: true
    add_index :impressions_by_stream_by_day, [:stream, :day], unique: true
  end
end
