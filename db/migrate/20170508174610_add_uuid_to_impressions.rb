class AddUuidToImpressions < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!

  def change
    add_column :impressions, :uuid, :uuid, unique: true
  end
end
