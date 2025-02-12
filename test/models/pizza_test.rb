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

end
