class ChangePriceToInteger < ActiveRecord::Migration[7.2]
  def change
    change_column(:pizzas, :price, :int)
    change_column(:toppings, :price, :int)
  end
end
