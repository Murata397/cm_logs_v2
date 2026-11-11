# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_11_133554) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "cars", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "manufacturer_name"
    t.string "car_model"
    t.string "car_name"
    t.integer "odometer"
    t.string "purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_cars_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "maintenance_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["maintenance_id"], name: "index_comments_on_maintenance_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "maintenance_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maintenance_id"], name: "index_favorites_on_maintenance_id"
    t.index ["user_id", "maintenance_id"], name: "index_favorites_on_user_id_and_maintenance_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "fuel_logs", force: :cascade do |t|
    t.integer "car_id", null: false
    t.date "refueled_on"
    t.integer "odometer"
    t.decimal "trip_distance"
    t.decimal "fuel_amount"
    t.string "fuel_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_fuel_logs_on_car_id"
  end

  create_table "group_notices", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_notices_on_group_id"
    t.index ["user_id"], name: "index_group_notices_on_user_id"
  end

  create_table "group_users", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "user_id"], name: "index_group_users_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_group_users_on_group_id"
    t.index ["user_id"], name: "index_group_users_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.string "name", null: false
    t.text "introduction"
    t.string "theme"
    t.text "rules"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "inspection_schedules", force: :cascade do |t|
    t.integer "car_id", null: false
    t.string "item"
    t.date "next_due_on"
    t.integer "next_due_odometer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_inspection_schedules_on_car_id"
  end

  create_table "maintenance_steps", force: :cascade do |t|
    t.integer "maintenance_id", null: false
    t.integer "position"
    t.string "title"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maintenance_id"], name: "index_maintenance_steps_on_maintenance_id"
  end

  create_table "maintenance_tools", force: :cascade do |t|
    t.integer "maintenance_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maintenance_id"], name: "index_maintenance_tools_on_maintenance_id"
  end

  create_table "maintenances", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "car_id", null: false
    t.string "title"
    t.date "maintenance_day"
    t.string "category"
    t.integer "work_difficulty"
    t.integer "work_time_minutes"
    t.integer "work_cost"
    t.text "summary"
    t.text "related_information"
    t.integer "status"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "favorites_count", default: 0, null: false
    t.index ["car_id"], name: "index_maintenances_on_car_id"
    t.index ["user_id"], name: "index_maintenances_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.text "introduction"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cars", "users"
  add_foreign_key "comments", "maintenances"
  add_foreign_key "comments", "users"
  add_foreign_key "favorites", "maintenances"
  add_foreign_key "favorites", "users"
  add_foreign_key "fuel_logs", "cars"
  add_foreign_key "group_notices", "groups"
  add_foreign_key "group_notices", "users"
  add_foreign_key "group_users", "groups"
  add_foreign_key "group_users", "users"
  add_foreign_key "groups", "users", column: "owner_id"
  add_foreign_key "inspection_schedules", "cars"
  add_foreign_key "maintenance_steps", "maintenances"
  add_foreign_key "maintenance_tools", "maintenances"
  add_foreign_key "maintenances", "cars"
  add_foreign_key "maintenances", "users"
end
