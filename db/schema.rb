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

ActiveRecord::Schema.define(version: 0) do

  create_table "battings", id: false, force: :cascade do |t|
    t.string  "game_id",   limit: 5,              null: false
    t.string  "player_id", limit: 16,             null: false
    t.string  "team_id",   limit: 8,              null: false
    t.integer "AB",        limit: 4
    t.integer "R",         limit: 4
    t.integer "H",         limit: 4
    t.integer "B2",        limit: 4,  default: 0
    t.integer "B3",        limit: 4,  default: 0
    t.integer "HR",        limit: 4,  default: 0
    t.integer "RBI",       limit: 4
    t.integer "BB",        limit: 4,  default: 0
    t.integer "SO",        limit: 4,  default: 0
    t.integer "IBB",       limit: 4,  default: 0
    t.integer "SF",        limit: 4,  default: 0
    t.integer "E",         limit: 4,  default: 0
    t.integer "GIDP",      limit: 4,  default: 0
    t.integer "order",     limit: 4,  default: 0, null: false
    t.integer "欄位1",       limit: 4
  end

  add_index "battings", ["game_id"], name: "game_id", using: :btree
  add_index "battings", ["player_id"], name: "player_id", using: :btree
  add_index "battings", ["team_id"], name: "team_id", using: :btree

  create_table "cups", primary_key: "cup_id", force: :cascade do |t|
    t.string  "cup_name", limit: 16
    t.integer "year",     limit: 4,  default: 0
    t.boolean "formal",   limit: 1
    t.boolean "official", limit: 1
  end

  add_index "cups", ["cup_id"], name: "cup_id", using: :btree

  create_table "fieldings", id: false, force: :cascade do |t|
    t.string  "game_id",   limit: 5,   null: false
    t.string  "player_id", limit: 16,  null: false
    t.string  "team_id",   limit: 8,   null: false
    t.string  "POS",       limit: 2,   null: false
    t.integer "InnOuts",   limit: 4
    t.integer "PO",        limit: 4
    t.integer "A",         limit: 4
    t.integer "E",         limit: 4
    t.integer "K",         limit: 4
    t.integer "欄位1",       limit: 4
    t.string  "欄位2",       limit: 255
  end

  add_index "fieldings", ["game_id"], name: "game_id", using: :btree
  add_index "fieldings", ["player_id"], name: "player_id", using: :btree
  add_index "fieldings", ["team_id"], name: "team_id", using: :btree

  create_table "games", primary_key: "game_id", force: :cascade do |t|
    t.string   "cup_id",       limit: 4
    t.datetime "time"
    t.string   "home_team_id", limit: 8
    t.integer  "home_score",   limit: 4,  default: 0
    t.integer  "home_ipouts",  limit: 4,  default: 0
    t.string   "away_team_id", limit: 8
    t.integer  "away_score",   limit: 4,  default: 0
    t.integer  "away_ipouts",  limit: 4,  default: 0
    t.boolean  "grassfield",   limit: 1,  default: true
    t.string   "mvp",          limit: 16
  end

  add_index "games", ["cup_id"], name: "cup_id", using: :btree
  add_index "games", ["game_id"], name: "game_id", using: :btree

  create_table "information", id: false, force: :cascade do |t|
    t.integer "id",          limit: 4
    t.string  "date",        limit: 13
    t.string  "description", limit: 23
    t.string  "is_public",   limit: 1
    t.string  "created_at",  limit: 26
    t.string  "updated_at",  limit: 26
  end

  create_table "members", id: false, force: :cascade do |t|
    t.string  "id",            limit: 12
    t.string  "number",        limit: 2
    t.string  "name",          limit: 3
    t.string  "nameEN",        limit: 14
    t.string  "birthday",      limit: 10
    t.string  "birthplaceCH",  limit: 3
    t.string  "birthplaceEN",  limit: 14
    t.string  "high_schoolCH", limit: 10
    t.string  "high_schoolEN", limit: 43
    t.string  "position",      limit: 6
    t.string  "bats",          limit: 1
    t.string  "throws",        limit: 1
    t.string  "created_at",    limit: 26
    t.string  "updated_at",    limit: 26
    t.integer "IM_age",        limit: 4
    t.integer "active",        limit: 4
    t.string  "leadership",    limit: 1
  end

  create_table "pitchings", id: false, force: :cascade do |t|
    t.string  "game_id",   limit: 5,              null: false
    t.string  "player_id", limit: 16,             null: false
    t.string  "team_id",   limit: 8,              null: false
    t.integer "W",         limit: 4
    t.integer "L",         limit: 4
    t.integer "SV",        limit: 4
    t.integer "IPouts",    limit: 4
    t.integer "H",         limit: 4
    t.integer "ER",        limit: 4
    t.integer "HR",        limit: 4
    t.integer "BB",        limit: 4
    t.integer "SO",        limit: 4
    t.integer "BAOpp",     limit: 4
    t.integer "IBB",       limit: 4
    t.integer "R",         limit: 4
    t.integer "order",     limit: 4,  default: 0
  end

  add_index "pitchings", ["game_id"], name: "game_id", using: :btree
  add_index "pitchings", ["player_id"], name: "player_id", using: :btree
  add_index "pitchings", ["team_id"], name: "team_id", using: :btree

  create_table "players", primary_key: "player_id", force: :cascade do |t|
    t.string  "player_fname", limit: 8
    t.string  "player_lname", limit: 8
    t.boolean "active",       limit: 1
    t.boolean "member",       limit: 1
  end

  add_index "players", ["player_id"], name: "player_id", using: :btree

  create_table "positions", primary_key: "POS", force: :cascade do |t|
    t.integer "pos_num", limit: 4, default: 0
    t.string  "field",   limit: 3
  end

  create_table "teams", primary_key: "team_id", force: :cascade do |t|
    t.string "team_name", limit: 12
  end

  add_index "teams", ["team_id"], name: "team_id", using: :btree

  create_table "users", id: false, force: :cascade do |t|
    t.integer "id",              limit: 4
    t.string  "name",            limit: 14
    t.string  "password_digest", limit: 60
    t.string  "revisable",       limit: 1
    t.string  "created_at",      limit: 26
    t.string  "updated_at",      limit: 26
    t.string  "remember_digest", limit: 10
  end

end
