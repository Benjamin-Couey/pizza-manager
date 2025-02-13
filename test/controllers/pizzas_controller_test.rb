require "test_helper"

class PizzasControllerPermissionsTest < ActionDispatch::IntegrationTest

	test "pizzas controller redirects non chefs to root" do
		get pizzas_path
		assert_redirected_to root_path
  	assert_equal "Only chefs may access that page", flash[:error]

		sign_in_as users(:owner)
		get edit_pizza_path(pizzas(:special).id)
		assert_redirected_to root_path
  	assert_equal "Only chefs may access that page", flash[:error]

		post pizzas_path, params: { pizza: { name: "New pizza" } }
		assert_redirected_to root_path
  	assert_equal "Only chefs may access that page", flash[:error]
	end

end

class PizzasControllerTest < ActionDispatch::IntegrationTest

	setup do
		sign_in_as users(:chef)
	end

	test "pizzas index action" do
		get pizzas_path
		assert_response :success
	end

	test "pizzas new action" do
		get new_pizza_path
		assert_response :success
	end

	test "pizzas create action" do
		num_pizzas = Pizza.all().count
		post pizzas_path, params: { pizza: { name: "New pizza" } }
		assert_redirected_to pizzas_path
		assert_equal "Sucessfully created pizza New pizza", flash[:notice]
		assert_equal num_pizzas + 1, Pizza.all().count
	end

	test "pizzas edit action" do
		get edit_pizza_path(pizzas(:special).id)
		assert_response :success
	end

	test "pizzas update action" do
		patch pizza_path(pizzas(:special).id), params: { pizza: { name: "The Extra Special" } }
		assert_redirected_to pizzas_path
		assert_equal "Sucessfully updated pizza The Extra Special", flash[:notice]
		assert_equal "The Extra Special", Pizza.find_by(id: pizzas(:special).id).name
	end

	test "pizzas destroy action" do
		num_pizzas = Pizza.all().count
		delete pizza_path(pizzas(:special).id)
		assert_redirected_to pizzas_path
		assert_equal "Pizza deleted", flash[:notice]
		assert_equal num_pizzas - 1, Pizza.all().count
	end

end
