class AddAdditionalFieldsToPizza < ActiveRecord::Migration[7.2]
  def change
    add_column :pizzas, :vegetarian, :boolean
    add_column :pizzas, :price, :float
    add_column :pizzas, :calories, :integer
  end
end
