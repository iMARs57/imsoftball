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

ActiveRecord::Schema.define(version: 20150701060600) do

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

  add_index "battings", ["game_id", "player_id", "team_id", "order"], name: "sqlite_autoindex_battings_1", unique: true
  add_index "battings", ["game_id"], name: "game_id"
  add_index "battings", ["player_id"], name: "battingplayer_id"
  add_index "battings", ["team_id"], name: "battingteam_id"

  create_table "cups", primary_key: "cup_id", force: :cascade do |t|
    t.text    "cup_name"
    t.integer "year"
    t.integer "formal"
    t.integer "official"
  end

  add_index "cups", ["cup_id"], name: "cup_id"
  add_index "cups", ["cup_id"], name: "sqlite_autoindex_cups_1", unique: true

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

  add_index "fieldings", ["game_id", "player_id", "team_id", "POS"], name: "sqlite_autoindex_fieldings_1", unique: true
  add_index "fieldings", ["game_id"], name: "fieldinggame_id"
  add_index "fieldings", ["player_id"], name: "player_id"
  add_index "fieldings", ["team_id"], name: "fieldingteam_id"

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

  add_index "games", ["cup_id"], name: "gamecup_id"
  add_index "games", ["game_id"], name: "game_id_1"
  add_index "games", ["game_id"], name: "sqlite_autoindex_games_1", unique: true

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

  add_index "pitchings", ["game_id", "player_id", "team_id"], name: "sqlite_autoindex_pitchings_1", unique: true
  add_index "pitchings", ["game_id"], name: "pitchinggame_id"
  add_index "pitchings", ["player_id"], name: "pitchingplayer_id"
  add_index "pitchings", ["team_id"], name: "pitchingteam_id"

  create_table "players", primary_key: "player_id", force: :cascade do |t|
    t.text    "player_fname"
    t.text    "player_lname"
    t.integer "active"
    t.integer "member"
  end

  add_index "players", ["player_id"], name: "player_id_1"
  add_index "players", ["player_id"], name: "sqlite_autoindex_players_1", unique: true

  create_table "positions", primary_key: "POS", force: :cascade do |t|
    t.integer "pos_num"
    t.text    "field"
  end

  add_index "positions", ["POS"], name: "sqlite_autoindex_positions_1", unique: true

  create_table "teams", primary_key: "team_id", force: :cascade do |t|
    t.text "team_name"
  end

  add_index "teams", ["team_id"], name: "sqlite_autoindex_teams_1", unique: true
  add_index "teams", ["team_id"], name: "team_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.boolean  "revisable"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "remember_digest"
  end

end
