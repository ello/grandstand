class HourlyImpressions < ActiveRecord::Migration[5.0]
  def change
    create_table :hourly_impressions do |t|
      t.datetime :starting_at
      t.string :stream_kind
      t.string :stream_id
      t.integer :logged_in_views
      t.integer :logged_out_views
    end

    add_index :hourly_impressions, [:starting_at, :stream_kind, :stream_id], name: 'hourly_impressions_full_index', unique: true
  end
end
