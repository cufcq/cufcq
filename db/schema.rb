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

ActiveRecord::Schema.define(version: 20140425040402) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: true do |t|
    t.string   "course_title"
    t.integer  "crse"
    t.string   "subject"
    t.string   "corrected_course_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.string   "college"
    t.string   "campus"
    t.string   "long_name"
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
    t.string   "onlinefcq"
    t.string   "bd_continuing_education"
    t.string   "instructor_last"
    t.string   "instructor_first"
    t.integer  "formsrequested"
    t.integer  "formsreturned"
    t.float    "courseoverall"
    t.float    "courseoverall_sd"
    t.float    "instructoroverall"
    t.float    "instructoroverall_sd"
    t.string   "hoursperwkinclclass"
    t.float    "priorinterest"
    t.float    "instreffective"
    t.float    "availability"
    t.float    "challenge"
    t.float    "howmuchlearned"
    t.float    "instrrespect"
    t.string   "course_title"
    t.string   "courseoverall_old"
    t.string   "courseoverall_sd_old"
    t.string   "instroverall_old"
    t.string   "instroverall_sd_old"
    t.string   "r_fair"
    t.string   "r_access"
    t.string   "workload"
    t.string   "r_divstu"
    t.string   "r_diviss"
    t.string   "r_presnt"
    t.string   "r_explan"
    t.string   "r_assign"
    t.string   "r_motiv"
    t.string   "r_learn"
    t.string   "r_complx"
    t.string   "campus"
    t.string   "college"
    t.string   "asdiv"
    t.string   "level"
    t.string   "fcqdept"
    t.string   "instr_group"
    t.integer  "i_num"
    t.string   "corrected_course_title"
    t.string   "activity_type"
    t.integer  "hours"
    t.integer  "n_eot"
    t.integer  "n_enroll"
    t.integer  "n_grade"
    t.float    "pct_grade"
    t.float    "avg_grd"
    t.float    "pct_a"
    t.float    "pct_b"
    t.float    "pct_c"
    t.float    "pct_d"
    t.float    "pct_f"
    t.float    "pct_c_minus_or_below"
    t.float    "pct_df"
    t.float    "pct_wdraw"
    t.float    "pct_incomp"
    t.integer  "n_pass"
    t.integer  "n_nocred"
    t.integer  "n_incomp"
    t.float    "workload_raw"
    t.float    "avgcourse"
    t.float    "avginstructor"
    t.string   "subject_label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fcqs", ["instructor_first", "instructor_last"], name: "index_fcqs_on_instructor_first_and_instructor_last", using: :btree

  create_table "instructors", force: true do |t|
    t.string   "instructor_first"
    t.string   "instructor_last"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
