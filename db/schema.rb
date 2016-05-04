# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160503203819) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.integer  "consumer_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "authorizations", ["consumer_id"], name: "index_authorizations_on_consumer_id", using: :btree

  create_table "bank_accounts", force: :cascade do |t|
    t.integer  "pro_id"
    t.string   "holder_name"
    t.string   "account_number"
    t.string   "bank_name"
    t.string   "bank_sort_code"
    t.string   "bank_address"
    t.string   "postcode"
    t.string   "country"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "start_at"
    t.integer  "sum"
    t.integer  "pro_id"
    t.integer  "consumer_id"
    t.integer  "treatment_id"
    t.boolean  "paid",         default: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "confirmed",    default: false
  end

  add_index "bookings", ["consumer_id"], name: "index_bookings_on_consumer_id", using: :btree
  add_index "bookings", ["pro_id"], name: "index_bookings_on_pro_id", using: :btree
  add_index "bookings", ["treatment_id"], name: "index_bookings_on_treatment_id", using: :btree

  create_table "consumers", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "profile_name"
    t.string   "postcode"
    t.boolean  "female"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "image"
    t.integer  "braintree_customer_id"
  end

  add_index "consumers", ["email"], name: "index_consumers_on_email", unique: true, using: :btree
  add_index "consumers", ["reset_password_token"], name: "index_consumers_on_reset_password_token", unique: true, using: :btree

  create_table "pros", force: :cascade do |t|
    t.string   "username"
    t.string   "business_name"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "member_of_id"
  end

  add_index "pros", ["email"], name: "index_pros_on_email", unique: true, using: :btree
  add_index "pros", ["reset_password_token"], name: "index_pros_on_reset_password_token", unique: true, using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "consumer_id"
    t.integer  "venue_id"
    t.integer  "ambiance"
    t.integer  "cleanliness"
    t.integer  "staff"
    t.integer  "value"
    t.text     "comment"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "reviews", ["booking_id"], name: "index_reviews_on_booking_id", using: :btree
  add_index "reviews", ["consumer_id"], name: "index_reviews_on_consumer_id", using: :btree
  add_index "reviews", ["venue_id"], name: "index_reviews_on_venue_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "treatment_groups", force: :cascade do |t|
    t.integer  "pro_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "treatments", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "pro_id"
    t.integer  "sale_price"
    t.integer  "price"
    t.string   "duration"
    t.string   "treatment_type"
    t.integer  "treatment_group_id"
  end

  create_table "venues", force: :cascade do |t|
    t.integer  "pro_id"
    t.string   "image"
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.string   "website"
    t.string   "primary_type"
    t.text     "description"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_foreign_key "authorizations", "consumers"
  add_foreign_key "bookings", "consumers"
  add_foreign_key "bookings", "pros"
  add_foreign_key "bookings", "treatments"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "consumers"
  add_foreign_key "reviews", "venues"
end
