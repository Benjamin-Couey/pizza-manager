class MakePizzaAndToppingHaveUniqueNames < ActiveRecord::Migration[7.2]
  def change
    add_index :pizzas, :name, unique: true
    add_index :toppings, :name, unique: true
  end
end
