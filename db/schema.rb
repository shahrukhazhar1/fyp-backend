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

ActiveRecord::Schema.define(version: 20180503222150) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.text     "text"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "latex",                   default: false
    t.string   "attachment",  limit: 255
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.string   "auth_token",    limit: 255
    t.integer  "quiz_user_id"
    t.integer  "quiz_admin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["auth_token"], name: "index_authentications_on_auth_token", unique: true, using: :btree

  create_table "billings", force: :cascade do |t|
    t.integer  "subscription_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "last_four",       limit: 255
    t.string   "card_type",       limit: 255
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "quiz_user_id"
    t.integer  "quiz_admin_id"
    t.integer  "quiz_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
    t.string   "posted_by",     limit: 255
    t.integer  "question_id"
  end

  add_index "comments", ["question_id"], name: "index_comments_on_question_id", using: :btree

  create_table "coupons", force: :cascade do |t|
    t.string   "code",              limit: 255
    t.string   "free_trial_length", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "attachment"
    t.string   "attachment2"
    t.boolean  "support",     default: false
  end

  create_table "devices", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",           limit: 255
    t.string   "device_id",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar",         limit: 255
    t.boolean  "is_enabled",                 default: false
    t.boolean  "default_device",             default: false
    t.boolean  "send_mail",                  default: true
    t.string   "fcm_token"
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "emergency_numbers", force: :cascade do |t|
    t.integer  "device_id"
    t.string   "name",         limit: 255
    t.string   "phone_number", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emergency_numbers", ["device_id"], name: "index_emergency_numbers_on_device_id", using: :btree

  create_table "grades", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grades", ["name"], name: "index_grades_on_name", unique: true, using: :btree

  create_table "install_apps", force: :cascade do |t|
    t.string   "app_name"
    t.string   "package_name"
    t.integer  "device_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "block_status", default: false
    t.string   "device_udid"
  end

  create_table "labels", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailing_list_entries", force: :cascade do |t|
    t.integer  "mailing_list_id"
    t.string   "name"
    t.string   "email"
    t.string   "unsubscribe_token"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "mailing_list_entries", ["mailing_list_id", "email"], name: "index_mailing_list_entries_on_mailing_list_id_and_email", unique: true, using: :btree
  add_index "mailing_list_entries", ["mailing_list_id"], name: "index_mailing_list_entries_on_mailing_list_id", using: :btree

  create_table "mailing_lists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.string   "stripe_id",     limit: 255
    t.float    "price"
    t.string   "interval",      limit: 255
    t.text     "features"
    t.boolean  "highlight"
    t.integer  "display_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_labels", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "label_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "quiz_id"
    t.text     "text"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hint",                       limit: 255
    t.text     "comment"
    t.boolean  "sample",                                 default: false
    t.text     "study_guide"
    t.string   "study_guide_attachment",     limit: 255
    t.string   "attachment",                 limit: 255
    t.boolean  "latex",                                  default: false
    t.string   "question_guide_pdf_preview", limit: 255
    t.string   "guide_filename",             limit: 255
  end

  add_index "questions", ["quiz_id"], name: "index_questions_on_quiz_id", using: :btree

  create_table "quiz_admins", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "authentication_token",   limit: 255
  end

  add_index "quiz_admins", ["authentication_token"], name: "index_quiz_admins_on_authentication_token", unique: true, using: :btree
  add_index "quiz_admins", ["email"], name: "index_quiz_admins_on_email", unique: true, using: :btree
  add_index "quiz_admins", ["reset_password_token"], name: "index_quiz_admins_on_reset_password_token", unique: true, using: :btree

  create_table "quiz_grades", force: :cascade do |t|
    t.integer  "quiz_id"
    t.integer  "grade_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quiz_grades", ["quiz_id", "grade_id"], name: "index_quiz_grades_on_quiz_id_and_grade_id", unique: true, using: :btree

  create_table "quiz_results", force: :cascade do |t|
    t.integer  "device_id"
    t.integer  "quiz_selection_id"
    t.integer  "correct",            default: [],    array: true
    t.integer  "wrong",              default: [],    array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "passed",             default: false
    t.integer  "passing_percentage"
    t.integer  "passing_val"
    t.integer  "quiz_user_id"
  end

  add_index "quiz_results", ["device_id"], name: "index_quiz_results_on_device_id", using: :btree
  add_index "quiz_results", ["quiz_selection_id"], name: "index_quiz_results_on_quiz_selection_id", using: :btree

  create_table "quiz_selections", force: :cascade do |t|
    t.integer  "device_id"
    t.integer  "quiz_id"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "owner",        default: false
    t.boolean  "active",       default: true
    t.integer  "quiz_user_id"
  end

  add_index "quiz_selections", ["device_id", "quiz_id"], name: "index_quiz_selections_on_device_id_and_quiz_id", using: :btree
  add_index "quiz_selections", ["device_id"], name: "index_quiz_selections_on_device_id", using: :btree
  add_index "quiz_selections", ["quiz_id"], name: "index_quiz_selections_on_quiz_id", using: :btree

  create_table "quiz_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "authentication_token",   limit: 255
    t.boolean  "email_alert",                        default: false
  end

  add_index "quiz_users", ["authentication_token"], name: "index_quiz_users_on_authentication_token", unique: true, using: :btree
  add_index "quiz_users", ["confirmation_token"], name: "index_quiz_users_on_confirmation_token", unique: true, using: :btree
  add_index "quiz_users", ["email"], name: "index_quiz_users_on_email", unique: true, using: :btree
  add_index "quiz_users", ["reset_password_token"], name: "index_quiz_users_on_reset_password_token", unique: true, using: :btree

  create_table "quizzes", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "subject",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                             default: 0
    t.string   "topic",                  limit: 255
    t.text     "description"
    t.integer  "position"
    t.integer  "row_order"
    t.integer  "passing_percentage"
    t.integer  "quiz_user_id"
    t.string   "quiz_status",            limit: 255
    t.text     "study_guide_text"
    t.text     "study_guide_comment"
    t.datetime "approval_date"
    t.string   "approved_by",            limit: 255
    t.string   "test_prep",              limit: 255
    t.string   "attachment",             limit: 255
    t.text     "supplement_text"
    t.text     "quiz_guide"
    t.string   "quiz_guide_attachment",  limit: 255
    t.string   "supplement_pdf_preview", limit: 255
    t.string   "quiz_guide_pdf_preview", limit: 255
    t.string   "supplement_filename",    limit: 255
    t.string   "guide_filename",         limit: 255
    t.integer  "course_id"
  end

  add_index "quizzes", ["course_id"], name: "index_quizzes_on_course_id", using: :btree
  add_index "quizzes", ["quiz_user_id"], name: "index_quizzes_on_quiz_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string  "label"
    t.integer "user_id"
  end

  add_index "roles", ["user_id"], name: "index_roles_on_user_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.string   "stripe_id",     limit: 255
    t.integer  "plan_id"
    t.string   "last_four",     limit: 255
    t.integer  "coupon_id"
    t.string   "card_type",     limit: 255
    t.float    "current_price"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "device_id"
    t.datetime "canceled_at"
  end

  create_table "tutorials", force: :cascade do |t|
    t.string   "page_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_mailing_lists", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "mailing_list_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "user_mailing_lists", ["mailing_list_id"], name: "index_user_mailing_lists_on_mailing_list_id", using: :btree
  add_index "user_mailing_lists", ["user_id"], name: "index_user_mailing_lists_on_user_id", using: :btree

  create_table "user_tutorials", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tutorial_id"
    t.boolean  "seen",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "authentication_token",   limit: 255
    t.string   "stripe_id",              limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.boolean  "send_email",                         default: true
    t.string   "tutorial_screen",        limit: 255, default: "0"
    t.boolean  "tutorial_seen",                      default: true
    t.datetime "subscription_start_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weekly_reports", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "device_id"
  end

  add_foreign_key "mailing_list_entries", "mailing_lists"
  add_foreign_key "roles", "users"
  add_foreign_key "user_mailing_lists", "mailing_lists"
  add_foreign_key "user_mailing_lists", "users"
end
