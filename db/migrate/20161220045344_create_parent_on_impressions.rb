class CreateParentOnImpressions < ActiveRecord::Migration[5.0]
  def up
    execute "SELECT partman.create_parent('public.impressions', 'created_at', 'time', 'daily')"
  end

  def down
    execute "SELECT partman.undo_partition_time('public.impressions')"
  end
end
