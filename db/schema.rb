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

ActiveRecord::Schema.define(version: 20140410002302) do

  create_table "courses", force: true do |t|
    t.string   "course_title"
    t.string   "crse"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.string   "college"
    t.string   "campus"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fcqs", force: true do |t|
    t.integer  "instructor_id"
    t.integer  "course_id"
    t.integer  "department_id"
    t.integer  "yearterm"
    t.string   "subject"
    t.integer  "crse"
    t.integer  "sec"
    t.string   "instructor_last"
    t.string   "instructor_first"
    t.integer  "forms_requested"
    t.integer  "forms_returned"
    t.string   "percentage_passed"
    t.float    "course_overall"
    t.float    "course_overall_SD"
    t.float    "instructor_overall"
    t.float    "instructor_overall_SD"
    t.string   "total_hours"
    t.float    "prior_interest"
    t.float    "effectiveness"
    t.float    "availability"
    t.float    "challenge"
    t.float    "amount_learned"
    t.float    "respect"
    t.string   "course_title"
    t.string   "campus"
    t.string   "college"
    t.string   "instructor_group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fcqs", ["course_title"], name: "index_fcqs_on_course_title"
  add_index "fcqs", ["instructor_first", "instructor_last"], name: "index_fcqs_on_instructor_first_and_instructor_last"

  create_table "instructors", force: true do |t|
    t.string   "instructor_first"
    t.string   "instructor_last"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
