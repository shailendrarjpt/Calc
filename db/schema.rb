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

ActiveRecord::Schema.define(version: 20161125221654) do

  create_table "basics", force: :cascade do |t|
    t.string   "customer"
    t.string   "project"
    t.string   "pricing"
    t.integer  "numidentities"
    t.integer  "authsource"
    t.integer  "expense"
    t.integer  "fixedcon"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "kickoff"
    t.integer  "pmrate"
    t.integer  "barate"
    t.integer  "archrate"
    t.integer  "onconrate"
    t.integer  "offconrate"
    t.integer  "discount"
  end

  create_table "idm_admins", force: :cascade do |t|
    t.string   "rardesign"
    t.integer  "ruleemail"
    t.integer  "usarules"
    t.string   "jmlcomplex"
    t.integer  "addlcomplex"
    t.integer  "addlmod"
    t.integer  "addlsimple"
    t.string   "fcomplex"
    t.integer  "otbplatform"
    t.integer  "otbappl"
    t.integer  "otbticket"
    t.integer  "custticket"
    t.string   "pwmgt"
    t.string   "async"
    t.integer  "targets"
    t.integer  "fgtpass"
    t.boolean  "pret"
    t.boolean  "psync"
    t.boolean  "wdesk"
    t.integer  "astrans"
    t.integer  "usonboard"
    t.integer  "cswfpm"
    t.integer  "cswfba"
    t.integer  "cswfcon"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "passpol"
    t.integer  "cswfarch"
  end

end
