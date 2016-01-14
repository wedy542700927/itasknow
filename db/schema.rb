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

ActiveRecord::Schema.define(version: 20160102124314) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "tasks_count"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["tasks_count"], name: "index_categories_on_tasks_count"

  create_table "task_comments", force: true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.integer  "to_user_id"
    t.integer  "kind"
    t.integer  "status"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_comments", ["task_id"], name: "index_task_comments_on_task_id"
  add_index "task_comments", ["to_user_id"], name: "index_task_comments_on_to_user_id"
  add_index "task_comments", ["user_id"], name: "index_task_comments_on_user_id"

  create_table "task_stars", force: true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_stars", ["task_id", "user_id"], name: "index_task_stars_on_task_id_and_user_id"

  create_table "task_views", force: true do |t|
    t.integer  "task_id"
    t.integer  "user_id"
    t.string   "ip"
    t.text     "param_string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_views", ["task_id", "ip", "created_at"], name: "index_task_views_on_task_id_and_ip_and_created_at"

  create_table "tasks", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "tags"
    t.text     "content"
    t.integer  "award"
    t.integer  "pledge"
    t.integer  "status"
    t.integer  "taker_id"
    t.integer  "view_count"
    t.integer  "star_count"
    t.integer  "comments_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  add_index "tasks", ["comments_count"], name: "index_tasks_on_comments_count"
  add_index "tasks", ["created_at"], name: "index_tasks_on_created_at"
  add_index "tasks", ["star_count"], name: "index_tasks_on_star_count"
  add_index "tasks", ["title"], name: "index_tasks_on_title"
  add_index "tasks", ["user_id"], name: "index_tasks_on_user_id"
  add_index "tasks", ["view_count"], name: "index_tasks_on_view_count"

  create_table "user_actives", force: true do |t|
    t.integer  "user_id"
    t.string   "type_name"
    t.string   "token"
    t.boolean  "used"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "student_id"
    t.string   "name"
    t.string   "description"
    t.integer  "credits"
    t.string   "email"
    t.boolean  "admin"
    t.datetime "last_login_time"
    t.datetime "last_reply_time"
    t.string   "nickname"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "activation"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["nickname"], name: "index_users_on_nickname"
  add_index "users", ["username"], name: "index_users_on_username"

end
