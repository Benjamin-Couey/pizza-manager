class LinkPizzaAndTopping < ActiveRecord::Migration[7.2]
  def change
    create_table :pizzas_toppings, id: false do |t|
        t.belongs_to :pizza
        t.belongs_to :topping
    end
  end
end
