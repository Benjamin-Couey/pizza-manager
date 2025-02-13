# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_02_13_140614) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pizzas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "vegetarian"
    t.float "price"
    t.integer "calories"
    t.index ["name"], name: "index_pizzas_on_name", unique: true
  end

  create_table "pizzas_toppings", id: false, force: :cascade do |t|
    t.bigint "pizza_id"
    t.bigint "topping_id"
    t.index ["pizza_id"], name: "index_pizzas_toppings_on_pizza_id"
    t.index ["topping_id"], name: "index_pizzas_toppings_on_topping_id"
  end

  create_table "toppings", force: :cascade do |t|
    t.string "name"
    t.boolean "vegetarian"
    t.float "price"
    t.integer "calories"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_toppings_on_name", unique: true
  end
end
