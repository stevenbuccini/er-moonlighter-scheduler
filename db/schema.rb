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

ActiveRecord::Schema.define(version: 20150505131902) do

  create_table "admin_assistants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doctors", force: :cascade do |t|
    t.integer  "shift_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pay_periods", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "is_open",    default: false
    t.string   "phase",      default: "1"
  end

  create_table "shifts", force: :cascade do |t|
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.boolean  "confirmed"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "doctor_id"
    t.integer  "pay_period_id"
    t.string   "gcal_event_etag"
    t.string   "gcal_event_id"
    t.text     "candidates",         default: "--- []\n"
    t.integer  "assigned_doctor_id"
    t.integer  "doctors_id"
  end

  add_index "shifts", ["doctors_id"], name: "index_shifts_on_doctors_id"

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "email",                      default: "", null: false
    t.string   "encrypted_password",         default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",              default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "type"
    t.integer  "pay_period_id"
    t.string   "phone_1"
    t.string   "phone_2"
    t.string   "phone_3"
    t.text     "comments"
    t.date     "last_shift_completion_date"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
