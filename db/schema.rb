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

ActiveRecord::Schema.define(version: 2020_04_20_090123) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "blueprints", force: :cascade do |t|
    t.string "url", null: false
    t.string "url_path", null: false
    t.integer "size", null: false
    t.string "content_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumb_url", default: "", null: false
    t.boolean "preview", default: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.text "description"
    t.integer "list_order", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "design_blueprints", force: :cascade do |t|
    t.bigint "design_id", null: false
    t.bigint "blueprint_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["blueprint_id"], name: "index_design_blueprints_on_blueprint_id"
    t.index ["design_id", "blueprint_id"], name: "index_design_blueprints_on_design_id_and_blueprint_id", unique: true
    t.index ["design_id"], name: "index_design_blueprints_on_design_id"
  end

  create_table "design_downloads", force: :cascade do |t|
    t.string "step", limit: 50, null: false
    t.string "url"
    t.bigint "design_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["design_id"], name: "index_design_downloads_on_design_id"
  end

  create_table "design_illustrations", force: :cascade do |t|
    t.bigint "design_id", null: false
    t.bigint "illustration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.index ["design_id", "illustration_id"], name: "index_design_illustrations_on_design_id_and_illustration_id", unique: true
    t.index ["design_id"], name: "index_design_illustrations_on_design_id"
    t.index ["illustration_id"], name: "index_design_illustrations_on_illustration_id"
  end

  create_table "designs", force: :cascade do |t|
    t.string "name", limit: 120, null: false
    t.text "description", null: false
    t.text "printing_settings"
    t.string "model_file_format"
    t.string "license_type", null: false
    t.boolean "allow_comments", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "category_id", null: false
    t.string "slug"
    t.integer "downloads_count", default: 0, null: false
    t.float "hourly_downloads_count", default: 0.0, null: false
    t.float "popularity_score", default: 0.0, null: false
    t.datetime "home_popular_at"
    t.integer "likes_count", default: 0, null: false
    t.datetime "hourly_downloads_count_at"
    t.text "cached_tag_names"
    t.index ["category_id"], name: "index_designs_on_category_id"
    t.index ["slug"], name: "index_designs_on_slug", unique: true
    t.index ["user_id"], name: "index_designs_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "gutentag_taggings", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "taggable_id", null: false
    t.string "taggable_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_gutentag_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id", "tag_id"], name: "unique_taggings", unique: true
    t.index ["taggable_type", "taggable_id"], name: "index_gutentag_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "gutentag_tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "taggings_count", default: 0, null: false
    t.index ["name"], name: "index_gutentag_tags_on_name", unique: true
    t.index ["taggings_count"], name: "index_gutentag_tags_on_taggings_count"
  end

  create_table "identities", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.text "auth_data_dump"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "illustrations", force: :cascade do |t|
    t.string "url", null: false
    t.string "url_path", null: false
    t.integer "size", null: false
    t.string "content_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "large_url", default: "", null: false
    t.string "medium_url", default: "", null: false
    t.string "thumb_url", default: "", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "sail_entries", force: :cascade do |t|
    t.string "value", null: false
    t.bigint "setting_id"
    t.bigint "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_sail_entries_on_profile_id"
    t.index ["setting_id"], name: "index_sail_entries_on_setting_id"
  end

  create_table "sail_profiles", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_sail_profiles_on_name", unique: true
  end

  create_table "sail_settings", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "value", null: false
    t.string "group"
    t.integer "cast_type", limit: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_settings_on_name", unique: true
  end

  create_table "user_avatars", force: :cascade do |t|
    t.string "letter_avatar_url", null: false
    t.string "letter_avatar_thumb_url", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_avatars_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "events_count", default: 0, null: false
    t.string "avatar_thumb_url", default: "", null: false
    t.string "avatar_url", default: "", null: false
    t.boolean "external", default: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "design_blueprints", "blueprints", on_delete: :cascade
  add_foreign_key "design_blueprints", "designs", on_delete: :cascade
  add_foreign_key "design_downloads", "designs", on_delete: :cascade
  add_foreign_key "design_illustrations", "designs", on_delete: :cascade
  add_foreign_key "design_illustrations", "illustrations", on_delete: :cascade
  add_foreign_key "designs", "categories", on_delete: :cascade
  add_foreign_key "designs", "users", on_delete: :cascade
  add_foreign_key "identities", "users"
  add_foreign_key "sail_entries", "sail_profiles", column: "profile_id"
  add_foreign_key "sail_entries", "sail_settings", column: "setting_id"
  add_foreign_key "user_avatars", "users", on_delete: :cascade
end
