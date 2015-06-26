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

ActiveRecord::Schema.define(version: 20150626025801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battings", id: false, force: :cascade do |t|
    t.text    "game_id",   null: false
    t.text    "player_id", null: false
    t.text    "team_id",   null: false
    t.integer "AB"
    t.integer "R"
    t.integer "H"
    t.integer "B2"
    t.integer "B3"
    t.integer "HR"
    t.integer "RBI"
    t.integer "BB"
    t.integer "SO"
    t.integer "IBB"
    t.integer "SF"
    t.integer "E"
    t.integer "GIDP"
    t.integer "order",     null: false
  end

  add_index "battings", ["game_id"], name: "game_id", using: :btree
  add_index "battings", ["player_id"], name: "battingplayer_id", using: :btree
  add_index "battings", ["team_id"], name: "battingteam_id", using: :btree

  create_table "cups", primary_key: "cup_id", force: :cascade do |t|
    t.text    "cup_name"
    t.integer "year"
    t.integer "formal"
    t.integer "official"
  end

  add_index "cups", ["cup_id"], name: "cup_id", using: :btree

  create_table "fieldings", id: false, force: :cascade do |t|
    t.text    "game_id",   null: false
    t.text    "player_id", null: false
    t.text    "team_id",   null: false
    t.text    "POS",       null: false
    t.integer "InnOuts"
    t.integer "PO"
    t.integer "A"
    t.integer "E"
    t.integer "K"
  end

  add_index "fieldings", ["game_id"], name: "fieldinggame_id", using: :btree
  add_index "fieldings", ["player_id"], name: "player_id", using: :btree
  add_index "fieldings", ["team_id"], name: "fieldingteam_id", using: :btree

  create_table "games", primary_key: "game_id", force: :cascade do |t|
    t.text    "cup_id"
    t.text    "time"
    t.text    "home_team_id"
    t.integer "home_score"
    t.integer "home_ipouts"
    t.text    "away_team_id"
    t.integer "away_score"
    t.integer "away_ipouts"
    t.integer "grassfield"
    t.text    "mvp"
  end

  add_index "games", ["cup_id"], name: "gamecup_id", using: :btree
  add_index "games", ["game_id"], name: "game_id_1", using: :btree

  create_table "information", force: :cascade do |t|
    t.date     "date"
    t.text     "description"
    t.boolean  "is_public"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "namecards", force: :cascade do |t|
    t.string   "name"
    t.string   "tel"
    t.string   "address"
    t.string   "company"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pitchings", id: false, force: :cascade do |t|
    t.text    "game_id",   null: false
    t.text    "player_id", null: false
    t.text    "team_id",   null: false
    t.integer "W"
    t.integer "L"
    t.integer "SV"
    t.integer "IPouts"
    t.integer "H"
    t.integer "ER"
    t.integer "HR"
    t.integer "BB"
    t.integer "SO"
    t.integer "BAOpp"
    t.integer "IBB"
    t.integer "R"
    t.integer "order"
  end

  add_index "pitchings", ["game_id"], name: "pitchinggame_id", using: :btree
  add_index "pitchings", ["player_id"], name: "pitchingplayer_id", using: :btree
  add_index "pitchings", ["team_id"], name: "pitchingteam_id", using: :btree

  create_table "players", primary_key: "player_id", force: :cascade do |t|
    t.text    "player_fname"
    t.text    "player_lname"
    t.integer "active"
    t.integer "member"
  end

  add_index "players", ["player_id"], name: "player_id_1", using: :btree

  create_table "positions", primary_key: "POS", force: :cascade do |t|
    t.integer "pos_num"
    t.text    "field"
  end

  create_table "teams", primary_key: "team_id", force: :cascade do |t|
    t.text "team_name"
  end

  add_index "teams", ["team_id"], name: "team_id", using: :btree

  add_foreign_key "battings", "games", primary_key: "game_id", name: "gamebatting", on_update: :nullify, on_delete: :nullify
  add_foreign_key "battings", "players", primary_key: "player_id", name: "playerbatting", on_update: :nullify, on_delete: :nullify
  add_foreign_key "battings", "teams", primary_key: "team_id", name: "teambatting", on_update: :nullify, on_delete: :nullify
  add_foreign_key "fieldings", "games", primary_key: "game_id", name: "gamefielding", on_update: :nullify, on_delete: :nullify
  add_foreign_key "fieldings", "players", primary_key: "player_id", name: "playerfielding", on_update: :nullify, on_delete: :nullify
  add_foreign_key "fieldings", "positions", column: "POS", primary_key: "POS", name: "positionfielding", on_update: :nullify, on_delete: :nullify
  add_foreign_key "fieldings", "teams", primary_key: "team_id", name: "teamfielding", on_update: :nullify, on_delete: :nullify
  add_foreign_key "games", "cups", primary_key: "cup_id", name: "cupgame", on_update: :nullify, on_delete: :nullify
  add_foreign_key "games", "teams", column: "away_team_id", primary_key: "team_id", name: "teamgame1", on_update: :nullify, on_delete: :nullify
  add_foreign_key "games", "teams", column: "home_team_id", primary_key: "team_id", name: "teamgame", on_update: :nullify, on_delete: :nullify
  add_foreign_key "pitchings", "games", primary_key: "game_id", name: "gamepitching", on_update: :nullify, on_delete: :nullify
  add_foreign_key "pitchings", "players", primary_key: "player_id", name: "playerpitching", on_update: :nullify, on_delete: :nullify
  add_foreign_key "pitchings", "teams", primary_key: "team_id", name: "teampitching", on_update: :nullify, on_delete: :nullify
end
