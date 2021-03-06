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

ActiveRecord::Schema.define(:version => 20110316231428) do

  create_table "answers", :force => true do |t|
    t.string   "answer"
    t.integer  "question_id"
    t.boolean  "correct",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problem_sets", :force => true do |t|
    t.string   "title"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_count", :default => 0
    t.text     "summary"
  end

  create_table "questions", :force => true do |t|
    t.string   "problem"
    t.integer  "problem_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",          :default => 0
  end

  create_table "responses", :force => true do |t|
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "result"
    t.integer  "user_id"
    t.integer  "problem_set_id", :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.boolean  "admin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
