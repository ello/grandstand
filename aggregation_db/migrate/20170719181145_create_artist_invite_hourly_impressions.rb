# frozen_string_literal: true

class CreateArtistInviteHourlyImpressions < ActiveRecord::Migration[5.0]
  def change
    create_table :artist_invite_hourly_impressions do |t|
      t.datetime :starting_at
      t.string :artist_invite_id
      t.string :stream_kind
      t.integer :logged_in_views
      t.integer :logged_out_views
    end

    add_index :artist_invite_hourly_impressions, %i[starting_at artist_invite_id stream_kind], name: 'artist_invite_hourly_impressions_full_index',
                                                                                               unique: true
  end
end
