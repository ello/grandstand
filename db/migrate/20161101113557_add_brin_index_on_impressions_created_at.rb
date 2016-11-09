class AddBrinIndexOnImpressionsCreatedAt < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!
  def up
    unless index_exists?(:impressions, name: :index_impressions_brin_on_created_at)
      add_index :impressions, :created_at, name: :index_impressions_brin_on_created_at, using: :brin, algorithm: :concurrently
    end
  end
  def down
    remove_index :impressions, :created_at, name: :index_impressions_brin_on_created_at
  end
end
