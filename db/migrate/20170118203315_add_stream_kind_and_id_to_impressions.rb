class AddStreamKindAndIdToImpressions < ActiveRecord::Migration[5.0]
  def change
    rename_column :impressions, :stream, :stream_kind
    add_column :impressions, :stream_id, :string
    update_view :impressions_by_stream_by_day, version: 2, revert_to_version: 1, materialized: true
    # This gets dropped by the previous statement, so need to manually recreate it here
    add_index :impressions_by_stream_by_day, [:stream_kind, :day], unique: true
  end
end
