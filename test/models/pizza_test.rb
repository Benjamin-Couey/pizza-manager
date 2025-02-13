require "test_helper"

class PizzaTest < ActiveSupport::TestCase

	test "should not allow duplicate pizza names" do
    dupPizza = Pizza.new(name: pizzas(:one).name)
		assert_not dupPizza.valid?
	end

	test "should not allow duplicate pizza topping combos" do
		dupPizza = Pizza.new(toppings: pizzas(:one).toppings)
		assert_not dupPizza.valid?
	end

	test "should allow pizza to have duplicates of a topping" do
		allToppingOnePizza = Pizza.new(toppings: [toppings(:one), toppings(:one), toppings(:one)])
		assert allToppingOnePizza.valid?
	end

	test "should not prevent updating pizza while keeping same toppings" do
		pizzas(:one).name = "newName"
		assert pizzas(:one).valid?
	end

	test "pizza is vegetarian only if it and all its toppings are vegetarian" do
		assert_not pizzas(:one).is_vegetarian()
		assert pizzas(:three).is_vegetarian()
		pizzas(:three).toppings << toppings(:one)
		assert_not pizzas(:three).is_vegetarian()
	end

	test "numeric_total returns sum of numeric attribute for pizza and all its toppings and nil for non numeric attributes" do
		assert_equal 4.5, pizzas(:one).numeric_total("price")
		assert_equal 3, pizzas(:one).numeric_total("calories")
		assert_nil pizzas(:one).numeric_total("name")
		assert_nil pizzas(:one).numeric_total("notafield")
	end

end
