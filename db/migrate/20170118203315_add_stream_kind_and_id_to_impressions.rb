# frozen_string_literal: true

class AddStreamKindAndIdToImpressions < ActiveRecord::Migration[5.0]
  def change
    rename_column :impressions, :stream, :stream_kind
    add_column :impressions, :stream_id, :string
  end
end
