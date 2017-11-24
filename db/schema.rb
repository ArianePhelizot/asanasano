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

ActiveRecord::Schema.define(version: 20171124140953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "person_type"
    t.string   "tag"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "birthday"
    t.string   "country_of_residence"
    t.string   "nationality"
    t.string   "legal_person_type"
    t.string   "legal_name"
    t.string   "legal_representative_first_name"
    t.string   "legal_representative_last_name"
    t.datetime "legal_representative_birthday"
    t.string   "headquarters_address"
    t.string   "legal_representative_country_of_residence"
    t.string   "legal_representative_nationality"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "mangopay_id"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "city"
    t.string   "region"
    t.string   "postal_code"
    t.index ["user_id"], name: "index_accounts_on_user_id", using: :btree
  end

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
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "experience"
    t.text     "languages",      default: [],                 array: true
    t.integer  "params_set_id"
    t.text     "training"
    t.boolean  "validated",      default: false, null: false
    t.boolean  "public",         default: false, null: false
    t.text     "availabilities"
    t.text     "locations"
    t.text     "price"
    t.text     "comments"
    t.string   "website"
    t.string   "facebook"
    t.string   "instagram"
    t.string   "youtube"
    t.string   "twitter"
    t.string   "linkedin"
    t.string   "pinterest"
    t.string   "insurance"
    t.index ["params_set_id"], name: "index_coaches_on_params_set_id", using: :btree
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

  create_table "ibans", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "mangopay_id"
    t.string   "tag"
    t.string   "iban"
    t.integer  "active"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["account_id"], name: "index_ibans_on_account_id", using: :btree
  end

  create_table "mangopay_logs", force: :cascade do |t|
    t.string   "event"
    t.integer  "user_id"
    t.string   "mangopay_answer"
    t.string   "error_logs"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["user_id"], name: "index_mangopay_logs_on_user_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "state"
    t.integer  "slot_id"
    t.integer  "amount_cents",         default: 0,     null: false
    t.json     "payment"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "mangopay_id"
    t.integer  "user_id"
    t.boolean  "settled",              default: false, null: false
    t.integer  "refund_mangopay_id"
    t.integer  "transfer_mangopay_id"
    t.index ["slot_id"], name: "index_orders_on_slot_id", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "params_sets", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.float    "fees_on_payout"
    t.integer  "payout_delay_in_days"
    t.integer  "free_refund_policy_in_hours"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "slots", force: :cascade do |t|
    t.date     "date"
    t.integer  "participants_min"
    t.integer  "price_cents",        default: 0,     null: false
    t.string   "price_currency",     default: "EUR", null: false
    t.string   "specificities"
    t.integer  "status",             default: 0
    t.integer  "course_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.datetime "start_at"
    t.datetime "end_at"
    t.integer  "payout_mangopay_id"
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
    t.string   "icon"
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
    t.string   "photo"
    t.index ["coach_id"], name: "index_users_on_coach_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "wallets", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "tag"
    t.integer  "mangopay_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["account_id"], name: "index_wallets_on_account_id", using: :btree
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "coaches", "params_sets"
  add_foreign_key "courses", "coaches"
  add_foreign_key "courses", "groups"
  add_foreign_key "courses", "sports"
  add_foreign_key "ibans", "accounts"
  add_foreign_key "mangopay_logs", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "slots", "courses"
  add_foreign_key "wallets", "accounts"
end
