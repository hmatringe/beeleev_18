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

ActiveRecord::Schema.define(version: 20180319182240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.string   "body"
    t.integer  "author_id"
    t.integer  "beeleever_post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["author_id"], name: "index_comments_on_author_id", using: :btree
  add_index "comments", ["beeleever_post_id"], name: "index_comments_on_beeleever_post_id", using: :btree

  create_table "connection_credits", force: true do |t|
    t.integer  "user_id"
    t.integer  "connection_id"
    t.date     "expires_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "external"
    t.text     "external_comments"
    t.date     "external_connection_date"
  end

  add_index "connection_credits", ["connection_id"], name: "index_connection_credits_on_connection_id", using: :btree
  add_index "connection_credits", ["user_id"], name: "index_connection_credits_on_user_id", using: :btree

  create_table "connection_demands", force: true do |t|
    t.integer  "requester_id"
    t.integer  "target_id"
    t.text     "description"
    t.string   "status"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connection_demands", ["requester_id"], name: "index_connection_demands_on_requester_id", using: :btree
  add_index "connection_demands", ["target_id"], name: "index_connection_demands_on_target_id", using: :btree

  create_table "connection_propositions", force: true do |t|
    t.integer  "for_user_id"
    t.integer  "proposed_user_id"
    t.integer  "admin_user_id"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connection_propositions", ["admin_user_id"], name: "index_connection_propositions_on_admin_user_id", using: :btree
  add_index "connection_propositions", ["for_user_id"], name: "index_connection_propositions_on_for_user_id", using: :btree
  add_index "connection_propositions", ["proposed_user_id"], name: "index_connection_propositions_on_proposed_user_id", using: :btree

  create_table "connection_requests", force: true do |t|
    t.integer  "author_id"
    t.string   "subject"
    t.text     "countries"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.text     "business_sectors", default: [], array: true
    t.text     "targets",          default: [], array: true
    t.text     "city"
  end

  add_index "connection_requests", ["author_id"], name: "index_connection_requests_on_author_id", using: :btree

  create_table "connections", force: true do |t|
    t.integer  "user1_id"
    t.integer  "user2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "status"
    t.text     "description"
    t.text     "reject_description"
    t.boolean  "send_feedback_reminders",           default: true
    t.date     "send_feedback_reminders_after"
    t.integer  "feedback_reminders_count",          default: 0
    t.datetime "beeleev_accepted_at"
    t.datetime "beeleev_rejected_at"
    t.datetime "user1_accepted_at"
    t.datetime "user1_rejected_at"
    t.datetime "user2_accepted_at"
    t.datetime "user2_rejected_at"
    t.integer  "connection_demand_reminders_count", default: 0
  end

  add_index "connections", ["user1_id", "user2_id"], name: "index_connections_on_user1_id_and_user2_id", using: :btree
  add_index "connections", ["user1_id"], name: "index_connections_on_user1_id", using: :btree
  add_index "connections", ["user2_id"], name: "index_connections_on_user2_id", using: :btree

  create_table "coupons", force: true do |t|
    t.string   "code"
    t.integer  "discount_percentage"
    t.integer  "validity_duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_templates", force: true do |t|
    t.string   "name"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment"
  end

  create_table "feedbacks", force: true do |t|
    t.integer  "author_id"
    t.integer  "connection_id"
    t.string   "contacted"
    t.integer  "quality_of_qualification"
    t.integer  "quality_of_contact"
    t.string   "prolific_contact"
    t.string   "met"
    t.boolean  "would_you_recommend"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["author_id"], name: "index_feedbacks_on_author_id", using: :btree
  add_index "feedbacks", ["connection_id"], name: "index_feedbacks_on_connection_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "cents"
    t.string   "currency"
    t.string   "stripe_charge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["product_id"], name: "index_orders_on_product_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "partner_categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "partners", force: true do |t|
    t.string   "url"
    t.string   "image"
    t.string   "title"
    t.text     "body"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "partner_category_id"
  end

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "subtitle"
    t.string   "text"
    t.text     "body"
    t.string   "illustration"
    t.boolean  "published",          default: false
    t.date     "publication_date",   default: '2014-12-22'
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "detailed_body"
    t.string   "type"
    t.integer  "author_id"
    t.text     "embedded_video_tag"
  end

  add_index "posts", ["author_id"], name: "index_posts_on_author_id", using: :btree

  create_table "products", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "amount"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "statement_descriptor"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "avatar"
    t.date     "created_date"
    t.integer  "week"
    t.string   "active"
    t.string   "sponsor"
    t.string   "source"
    t.string   "profil"
    t.string   "prospects"
    t.string   "civility"
    t.string   "nationalite"
    t.string   "city"
    t.string   "country"
    t.string   "cellphone"
    t.string   "position"
    t.string   "company"
    t.text     "activities_1"
    t.text     "activities_2"
    t.string   "turnover"
    t.string   "staff_volume"
    t.string   "website"
    t.string   "url_profile"
    t.string   "meeting_form"
    t.string   "status"
    t.string   "provider_public_profile_url"
    t.string   "encrypted_password",               default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "phone"
    t.string   "twitter_account"
    t.string   "skype_account"
    t.string   "spoken_languages",                 default: [],                 array: true
    t.string   "expertises",                       default: [],                 array: true
    t.date     "date_of_birth"
    t.string   "entrepreneur_clubs"
    t.boolean  "investment_activity"
    t.string   "year_of_creation"
    t.text     "description"
    t.string   "tagline"
    t.string   "business_model"
    t.boolean  "international_activity"
    t.text     "international_activity_countries", default: [],                 array: true
    t.string   "growth_rate"
    t.text     "current_customers"
    t.text     "current_partners"
    t.boolean  "hiring_objectives"
    t.boolean  "phone_interview_realized",         default: false
    t.integer  "new_application_reminder_count",   default: 0
    t.text     "application_reject_reason"
    t.string   "business_sectors",                 default: [],                 array: true
    t.string   "investment_levels",                default: [],                 array: true
    t.integer  "activate_user_reminder_count",     default: 0
    t.datetime "activated_at"
    t.string   "stripe_customer_id"
    t.boolean  "can_post",                         default: true
    t.string   "company_description",              default: ""
    t.string   "facebook_username",                default: ""
    t.string   "company_logo"
    t.string   "company_twitter_account"
    t.string   "company_facebook_account"
    t.string   "company_linkedin_account"
  end

  add_index "users", ["expertises"], name: "index_users_on_expertises", using: :gin
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  Foreigner.load
  add_foreign_key "partners", "partner_categories", name: "partners_partner_category_id_fk"

end
