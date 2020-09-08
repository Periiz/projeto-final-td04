# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_08_030929) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "collaborators", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
    t.string "social_name"
    t.date "birth_date"
    t.string "position"
    t.string "sector"
    t.integer "notifications_number", default: 0
    t.index ["email"], name: "index_collaborators_on_email", unique: true
    t.index ["reset_password_token"], name: "index_collaborators_on_reset_password_token", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.string "text"
    t.integer "product_id", null: false
    t.integer "collaborator_id", null: false
    t.datetime "post_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["collaborator_id"], name: "index_comments_on_collaborator_id"
    t.index ["product_id"], name: "index_comments_on_product_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "text"
    t.integer "collaborator_id", null: false
    t.integer "negotiation_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["collaborator_id"], name: "index_messages_on_collaborator_id"
    t.index ["negotiation_id"], name: "index_messages_on_negotiation_id"
  end

  create_table "negotiations", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "collaborator_id", null: false
    t.datetime "date_of_start"
    t.datetime "date_of_end"
    t.decimal "final_price"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "seller_id"
    t.index ["collaborator_id"], name: "index_negotiations_on_collaborator_id"
    t.index ["product_id"], name: "index_negotiations_on_product_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "product_category_id", null: false
    t.string "description"
    t.decimal "sale_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "collaborator_id", null: false
    t.integer "status", default: 0
    t.string "seller_domain"
    t.index ["collaborator_id"], name: "index_products_on_collaborator_id"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "collaborators"
  add_foreign_key "comments", "products"
  add_foreign_key "messages", "collaborators"
  add_foreign_key "messages", "negotiations"
  add_foreign_key "negotiations", "collaborators"
  add_foreign_key "negotiations", "products"
  add_foreign_key "products", "collaborators"
  add_foreign_key "products", "product_categories"
end
