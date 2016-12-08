# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161208200518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ar_internal_metadata", primary_key: "key", id: :string, force: :cascade do |t|
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impressions", id: false, force: :cascade do |t|
    t.string   "viewer_id"
    t.string   "post_id",                  null: false
    t.string   "author_id",                null: false
    t.datetime "created_at", precision: 4, null: false
    t.index ["author_id", "post_id", "created_at"], name: "index_impressions_on_author_id_and_post_id_and_created_at", unique: true, using: :btree
    t.index ["created_at"], name: "index_impressions_brin_on_created_at", using: :brin
  end


  create_view :impressions_by_days, materialized: true,  sql_definition: <<-SQL
      SELECT date_trunc('day'::text, impressions.created_at) AS day,
      count(1) AS ct
     FROM impressions
    GROUP BY (date_trunc('day'::text, impressions.created_at));
  SQL

  add_index "impressions_by_days", ["day"], name: "index_impressions_by_days_on_day", unique: true, using: :btree

  create_view :impressions_by_post_by_days, materialized: true,  sql_definition: <<-SQL
      SELECT date_trunc('day'::text, impressions.created_at) AS day,
      impressions.post_id,
      count(1) AS ct
     FROM impressions
    GROUP BY (date_trunc('day'::text, impressions.created_at)), impressions.post_id;
  SQL

  add_index "impressions_by_post_by_days", ["post_id", "day"], name: "index_impressions_by_post_by_days_on_post_id_and_day", unique: true, using: :btree

  create_view :impressions_by_author_by_days, materialized: true,  sql_definition: <<-SQL
      SELECT date_trunc('day'::text, impressions.created_at) AS day,
      impressions.author_id,
      count(1) AS ct
     FROM impressions
    GROUP BY (date_trunc('day'::text, impressions.created_at)), impressions.author_id;
  SQL

  add_index "impressions_by_author_by_days", ["author_id", "day"], name: "index_impressions_by_author_by_days_on_author_id_and_day", unique: true, using: :btree

end
