class AddUuidToImpressions < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!

  def change
    add_column :impressions, :uuid, :uuid
    add_index :impressions, :uuid, where: "uuid IS NULL", algorithm: :concurrently
  end
end
