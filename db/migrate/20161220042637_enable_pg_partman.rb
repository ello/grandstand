# frozen_string_literal: true

class EnablePgPartman < ActiveRecord::Migration[5.0]
  def up
    create_schema 'partman'
    execute 'CREATE EXTENSION IF NOT EXISTS pg_partman WITH SCHEMA partman'
  end

  def down
    execute 'DROP EXTENSION IF EXISTS pg_partman'
    drop_schema 'partman'
  end
end
