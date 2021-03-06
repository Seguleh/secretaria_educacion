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

ActiveRecord::Schema.define(version: 20160513185258) do

  create_table "bitacoras", force: :cascade do |t|
    t.string   "usuario_cedula", limit: 255
    t.datetime "fecha_hora"
    t.string   "ip_origen",      limit: 255
    t.string   "descripcion",    limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "docentes", force: :cascade do |t|
    t.string   "nombre",           limit: 255
    t.string   "apellido",         limit: 255
    t.string   "email",            limit: 255
    t.integer  "numero_fijo",      limit: 4
    t.integer  "numero_celular",   limit: 4
    t.string   "profesion",        limit: 255
    t.string   "municipio",        limit: 255
    t.date     "fecha_nacimiento"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "nombre",            limit: 50
    t.string   "apellido",          limit: 50
    t.string   "email",             limit: 150
    t.integer  "numero_fijo",       limit: 4
    t.integer  "numero_celular",    limit: 8
    t.string   "profesion",         limit: 150
    t.string   "municipio",         limit: 150
    t.date     "fecha_nacimiento"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "password_digest",   limit: 255
    t.string   "remember_digest",   limit: 255
    t.boolean  "admin",             limit: 1
    t.string   "activation_digest", limit: 255
    t.boolean  "activated",         limit: 1,   default: false
    t.datetime "activated_at"
    t.string   "reset_digest",      limit: 255
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
