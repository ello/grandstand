# frozen_string_literal: true

class AddInviteIdToImpressions < ActiveRecord::Migration[5.0]
  def change
    add_column :impressions, :artist_invite_id, :string
  end
end
