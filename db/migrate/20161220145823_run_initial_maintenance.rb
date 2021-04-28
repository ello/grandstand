# frozen_string_literal: true

class RunInitialMaintenance < ActiveRecord::Migration[5.0]
  def up
    execute 'SELECT partman.run_maintenance()'
  end

  def down
    # No-op
  end
end
