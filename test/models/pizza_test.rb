require "test_helper"

class PizzaTest < ActiveSupport::TestCase

	test "should not allow duplicate pizza names" do
    dupPizza = Pizza.new(name: pizzas(:special).name)
		assert_not dupPizza.valid?
	end

	test "should not allow duplicate pizza topping combos" do
		dupPizza = Pizza.new(toppings: pizzas(:special).toppings)
		assert_not dupPizza.valid?
	end

	test "should allow pizza to have duplicates of a topping" do
		allToppingOnePizza = Pizza.new(toppings: [toppings(:sausage), toppings(:sausage), toppings(:sausage)])
		assert allToppingOnePizza.valid?
	end

	test "should not prevent updating pizza while keeping same toppings" do
		pizzas(:special).name = "newName"
		assert pizzas(:special).valid?
	end

	test "pizza is vegetarian only if it and all its toppings are vegetarian" do
		assert_not pizzas(:special).is_vegetarian()
		assert pizzas(:veg_mushroom).is_vegetarian()
		pizzas(:veg_mushroom).toppings << toppings(:sausage)
		assert_not pizzas(:veg_mushroom).is_vegetarian()
	end

	test "numeric_total returns sum of numeric attribute for pizza and all its toppings and nil for non numeric attributes" do
		assert_equal 4.5, pizzas(:special).numeric_total("price")
		assert_equal 30, pizzas(:special).numeric_total("calories")
		assert_nil pizzas(:special).numeric_total("name")
		assert_nil pizzas(:special).numeric_total("notafield")
	end

end
