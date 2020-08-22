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

ActiveRecord::Schema.define(version: 20200822161143) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "name", default: ""
    t.string "caption", default: ""
    t.string "picture", default: ""
    t.float "reward", default: 1.0
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.integer "icon_index"
  end

  create_table "chants", force: :cascade do |t|
    t.string "title", default: ""
    t.text "content", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", default: "2020-08-18 14:08:31", null: false
    t.datetime "updated_at", default: "2020-08-18 14:08:31", null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sender_type"
    t.bigint "sender_id"
    t.integer "chat_id"
    t.string "picture"
    t.integer "type_message"
    t.boolean "status", default: false
    t.string "sender_name", default: ""
    t.string "sender_avatar", default: ""
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["sender_type", "sender_id"], name: "index_messages_on_sender_type_and_sender_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "picture"
    t.string "caption1"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "subname"
    t.string "price", null: false
    t.integer "category_id"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "superusers", force: :cascade do |t|
    t.string "login", null: false
    t.string "password_digest"
    t.string "btn1"
    t.string "btn2"
    t.string "btn3"
    t.string "push_token"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_id", default: 0
    t.index ["room_id"], name: "index_superusers_on_room_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "password_digest"
    t.string "phone_number", null: false
    t.string "push_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.boolean "online", default: false, null: false
    t.string "surname", default: ""
    t.string "birthday", default: ""
    t.string "gender", default: ""
    t.string "email", default: ""
    t.string "caption", default: ""
    t.float "rank", default: 1.0
    t.jsonb "basket"
    t.string "name", default: ""
    t.string "avatar"
    t.jsonb "achievements"
    t.index ["birthday"], name: "index_users_on_birthday"
    t.index ["email"], name: "index_users_on_email"
    t.index ["gender"], name: "index_users_on_gender"
    t.index ["rank"], name: "index_users_on_rank"
  end

end
