# frozen_string_literal: true

class AddStreamToImpressions < ActiveRecord::Migration[5.0]
  def change
    add_column :impressions, :stream, :string
  end
end
