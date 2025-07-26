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

ActiveRecord::Schema[7.1].define(version: 2025_07_19_064555) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "corporate_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "corporate_categories_products", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "corporate_category_id", null: false
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "materials_products", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "material_id", null: false
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.string "session_id"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_styles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_styles_products", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "product_style_id", null: false
  end

  create_table "products", force: :cascade do |t|
    t.integer "database_id"
    t.string "SKU"
    t.string "name"
    t.text "description"
    t.integer "parent_id"
    t.string "colour_value"
    t.string "size_value"
    t.decimal "price", precision: 10, scale: 2
    t.string "stock_status"
    t.integer "stock_quantity"
    t.string "image_url"
    t.string "slug"
    t.string "product_type"
    t.decimal "weight", precision: 6, scale: 2
    t.decimal "length", precision: 6, scale: 2
    t.decimal "width", precision: 6, scale: 2
    t.decimal "height", precision: 6, scale: 2
    t.string "customiser_template"
    t.string "background_colour"
    t.string "personalisation_options"
    t.bigint "quality_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["SKU"], name: "index_products_on_SKU", unique: true
    t.index ["quality_id"], name: "index_products_on_quality_id"
    t.index ["slug"], name: "index_products_on_slug"
  end

  create_table "products_sports", id: false, force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "sport_id", null: false
  end

  create_table "qualities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sports", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_designs", force: :cascade do |t|
    t.string "cloudinary_url"
    t.string "user_text"
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.bigint "order_id", null: false
    t.boolean "finished"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_user_designs_on_order_id"
    t.index ["product_id"], name: "index_user_designs_on_product_id"
    t.index ["user_id"], name: "index_user_designs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "qualities"
  add_foreign_key "user_designs", "orders"
  add_foreign_key "user_designs", "products"
  add_foreign_key "user_designs", "users"
end
