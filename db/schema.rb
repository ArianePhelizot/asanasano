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

ActiveRecord::Schema.define(version: 20170715142305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "attachinary_files", force: :cascade do |t|
    t.string   "attachinariable_type"
    t.integer  "attachinariable_id"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree
  end

  create_table "coaches", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "experience"
    t.text     "languages",   default: [],              array: true
  end

  create_table "coaches_groups", id: false, force: :cascade do |t|
    t.integer "coach_id", null: false
    t.integer "group_id", null: false
    t.index ["coach_id", "group_id"], name: "index_coaches_groups_on_coach_id_and_group_id", using: :btree
  end

  create_table "coaches_sports", id: false, force: :cascade do |t|
    t.integer "coach_id", null: false
    t.integer "sport_id", null: false
    t.index ["coach_id", "sport_id"], name: "index_coaches_sports_on_coach_id_and_sport_id", using: :btree
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "content"
    t.string   "address"
    t.float    "lat"
    t.float    "lng"
    t.string   "meeting_point"
    t.integer  "capacity_max"
    t.string   "details"
    t.integer  "group_id"
    t.integer  "coach_id"
    t.integer  "sport_id"
    t.integer  "status",        default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["coach_id"], name: "index_courses_on_coach_id", using: :btree
    t.index ["group_id"], name: "index_courses_on_group_id", using: :btree
    t.index ["sport_id"], name: "index_courses_on_sport_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_groups_on_owner_id", using: :btree
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "user_id",  null: false
    t.integer "group_id", null: false
    t.index ["user_id", "group_id"], name: "index_groups_users_on_user_id_and_group_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "state"
    t.integer  "slot_id"
    t.integer  "amount_cents", default: 0, null: false
    t.json     "payment"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["slot_id"], name: "index_orders_on_slot_id", using: :btree
  end

  create_table "slots", force: :cascade do |t|
    t.date     "date"
    t.integer  "participants_min"
    t.integer  "price_cents",      default: 0,     null: false
    t.string   "price_currency",   default: "EUR", null: false
    t.string   "specificities"
    t.integer  "status",           default: 0
    t.integer  "course_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.index ["course_id"], name: "index_slots_on_course_id", using: :btree
  end

  create_table "slots_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "slot_id", null: false
    t.index ["user_id", "slot_id"], name: "index_slots_users_on_user_id_and_slot_id", using: :btree
  end

  create_table "sports", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "coach_id"
    t.string   "phone_number"
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_picture_url"
    t.string   "token"
    t.datetime "token_expiry"
    t.boolean  "admin",                  default: false, null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.index ["coach_id"], name: "index_users_on_coach_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "courses", "coaches"
  add_foreign_key "courses", "groups"
  add_foreign_key "courses", "sports"
  add_foreign_key "slots", "courses"
end
