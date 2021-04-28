# frozen_string_literal: true

class AddIndexOnImpressionsViewerId < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!

  def change
    add_index :impressions, :viewer_id, using: :btree, algorithm: :concurrently
  end
end
