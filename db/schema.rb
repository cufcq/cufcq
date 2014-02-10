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

ActiveRecord::Schema.define(version: 20140210023240) do

  create_table "fcqs", force: true do |t|
    t.integer  "yearterm"
    t.string   "subject"
    t.integer  "crse"
    t.integer  "sec"
    t.string   "instructor_last"
    t.string   "instructor_first"
    t.integer  "formsrequested"
    t.integer  "formsReturned"
    t.string   "courseOverallPctValid"
    t.float    "courseOverall"
    t.float    "courseOverall_SD"
    t.float    "instructorOverall"
    t.float    "instructorOverall_SD"
    t.string   "hoursPerWkInclClass"
    t.float    "priorInterest"
    t.float    "instrEffective"
    t.float    "availability"
    t.float    "challenge"
    t.float    "howMuchLearned"
    t.float    "instrRespect"
    t.string   "crsTitle"
    t.string   "campus"
    t.string   "college"
    t.string   "instr_Group"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
