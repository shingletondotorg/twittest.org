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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120319101836) do

  create_table "conversation_threads", :force => true do |t|
    t.integer  "conversation_id"
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "micropost_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "turing_user_id"
    t.boolean  "is_visible",     :default => false
    t.boolean  "report_user",    :default => false
    t.boolean  "penalise_user",  :default => false
    t.integer  "penalised_by"
    t.integer  "reported_by"
    t.integer  "approved_by"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible"
  end

  create_table "turing_users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.integer  "turing_user_id"
    t.integer  "school_id"
    t.string   "last_name"
    t.string   "display_name"
    t.boolean  "has_voted",          :default => false
    t.integer  "total_score",        :default => 0
    t.integer  "votes_real",         :default => 0
    t.integer  "votes_fake",         :default => 0
    t.integer  "voting_real",        :default => 0
    t.integer  "voting_fake",        :default => 0
    t.boolean  "is_trusted",         :default => false
    t.integer  "n_reported",         :default => 0
    t.integer  "n_approved",         :default => 0
    t.integer  "n_penalised",        :default => 0
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "micropost_id"
    t.integer  "vote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["micropost_id"], :name => "index_votes_on_micropost_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
