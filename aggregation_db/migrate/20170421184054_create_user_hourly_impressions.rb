# frozen_string_literal: true

class CreateUserHourlyImpressions < ActiveRecord::Migration[5.0]
  def change
    create_table :user_hourly_impressions do |t|
      t.string :author_id, null: false
      t.datetime :starting_at, null: false
      t.integer :views, null: false
    end

    add_index :user_hourly_impressions, %i[author_id starting_at], name: 'user_hourly_impressions_full_index', unique: true
  end
end
