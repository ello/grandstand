# frozen_string_literal: true

# rubocop:disable Rails/CreateTableWithTimestamps
class CreateImpressions < ActiveRecord::Migration[5.0]
  def change
    create_table :impressions, id: false do |t|
      t.string :viewer_id
      t.string :post_id, null: false
      t.string :author_id, null: false
      t.timestamp :created_at, precision: 4, null: false
    end

    add_index :impressions, %i[author_id post_id created_at], unique: true
  end
end
# rubocop:enable Rails/CreateTableWithTimestamps
