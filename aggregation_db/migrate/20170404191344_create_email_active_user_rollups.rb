class CreateEmailActiveUserRollups < ActiveRecord::Migration[5.0]
  def change
    create_table :email_active_user_rollups do |t|
      t.datetime :day
      t.integer :day_total
      t.integer :thirty_day_total
    end

    add_index :email_active_user_rollups, :day, unique: true
  end
end
