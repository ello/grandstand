# frozen_string_literal: true

class EnableConstraintExclusion < ActiveRecord::Migration[5.0]
  def up
    execute "ALTER DATABASE #{ActiveRecord::Base.connection.current_database} SET constraint_exclusion = on"
  end

  def down
    execute "ALTER DATABASE #{ActiveRecord::Base.connection.current_database} SET constraint_exclusion = off"
  end
end
