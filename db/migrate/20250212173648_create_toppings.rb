class CreateToppings < ActiveRecord::Migration[7.2]
  def change
    create_table :toppings do |t|
      t.string :name
      t.boolean :vegetarian
      t.float :price
      t.integer :calories

      t.timestamps
    end
  end
end
