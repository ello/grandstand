class CreateImpressionsByEmailByDays < ActiveRecord::Migration[5.0]
  def change
    create_view :impressions_by_email_by_days, materialized: true
    add_index :impressions_by_email_by_days, [:email, :day], unique: true
  end
end
