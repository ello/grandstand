# frozen_string_literal: true

class CleanUpImpressionsIndices < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!

  def up
    remove_index :impressions, name: :index_impressions_brin_on_created_at
    add_index :impressions, %i[created_at author_id post_id], unique: true, algorithm: :concurrently
    remove_index :impressions, %i[author_id post_id created_at]
  end

end
