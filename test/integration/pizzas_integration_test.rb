require "test_helper"

class PizzasIntegrationTest < ActionDispatch::IntegrationTest

	setup do
		sign_in_as users(:chef)
	end

	test "visit pizzas page and see table of pizzas" do
		get pizzas_path
		assert_response :success
		assert_select "h1", "Pizzas"
		# Two rows per pizza (one for pizza, one for total) and a row for each topping of each pizza
		total_rows = pizzas.count() * 2
		pizzas.each do |pizza|
			total_rows += pizza.toppings.size
		end
		assert_select "tbody tr", total_rows
		assert_select "tbody tr td", pizzas(:special).name
		assert_select "tbody tr td a[href=?]", edit_pizza_path(pizzas(:special).id)
		assert_select "tbody tr td form[action=?]", pizza_path(pizzas(:special).id) do
			assert_select "button", "Delete"
		end
		assert_select "tbody tr td form[action=?]", topping_path(toppings(:sausage).id), 0
		assert_select "tbody tr td a[href=?]", edit_topping_path(toppings(:sausage).id), 0
		assert_select "tbody tr td a[href=?]", edit_topping_path(toppings(:mushroom).id), 0
		assert_select "tbody tr td", pizzas(:sausage_pie).name
		assert_select "tbody tr td", pizzas(:veg_mushroom).name
	end

	test "visit pizzas page and create a new pizza" do
		get pizzas_path
		assert_response :success

		get new_pizza_path
		assert_response :success
		assert_one_pizzas_form_present
		assert_select "form input[value=?]", "Create Pizza"

		assert_select "tbody tr td", false, toppings(:green_peppers).name

		post pizzas_path, params: { pizza: { name: "New pizza", vegetarian: true, price: 10.5, calories: 100, topping_ids: [toppings(:green_peppers).id] } }
		assert_redirected_to pizzas_path
		follow_redirect!
		assert_select "tbody tr td", "New pizza"
		assert_select "tbody tr td", "10.5"
		assert_select "tbody tr td", "100"
		assert_select "tbody tr td", toppings(:green_peppers).name

		post pizzas_path, params: { pizza: { name: pizzas(:special).name } }
		assert_response :unprocessable_entity
		assert_select "div", "There was an issue creating the pizza: [\"Name has already been taken\"]"

		post pizzas_path, params: { pizza: { name: "Totally original pizza", topping_ids: [toppings(:green_peppers).id] } }
		assert_response :unprocessable_entity
		assert_select "div", "There was an issue creating the pizza: [\"Toppings are a combination already in use by the pizza New pizza\"]"
	end

	test "visit pizzas page and update a pizza" do
		get pizzas_path
		assert_response :success

		get edit_pizza_path(pizzas(:special).id)
		assert_response :success
		assert_one_pizzas_form_present( pizzas(:special) )
		assert_select "form input[value=?]", "Update Pizza"

		patch pizza_path(pizzas(:special).id), params: { pizza: { name: "The Extra Special", vegetarian: true, price: 10.5, calories: 100, topping_ids: [toppings(:green_peppers).id] } }
		assert_redirected_to pizzas_path
		follow_redirect!
		assert_select "tbody tr td", "The Extra Special"
		assert_select "tbody tr td", "10.5"
		assert_select "tbody tr td", "100"
		assert_select "tbody tr td", toppings(:green_peppers).name
		assert_select "tbody tr td", {count: 0, text: pizzas(:special).name}

		patch pizza_path(pizzas(:special).id), params: { pizza: { name: pizzas(:sausage_pie).name } }
		assert_response :unprocessable_entity
		assert_select "div", "There was an issue updating the pizza: [\"Name has already been taken\"]"

		patch pizza_path(pizzas(:special).id), params: { pizza: { name: "Totally original pizza", topping_ids: [toppings(:sausage).id] } }
		assert_response :unprocessable_entity
		assert_select "div", "There was an issue updating the pizza: [\"Toppings are a combination already in use by the pizza #{pizzas(:sausage_pie).name}\"]"
	end

	test "visit pizzas page and delete a pizza" do
		get pizzas_path
		assert_response :success

		delete pizza_path(pizzas(:special).id)
		assert_redirected_to pizzas_path
		follow_redirect!
		assert_select "tbody tr td", {count: 0, text: pizzas(:special).name}
	end

	private

	def assert_one_pizzas_form_present( pizza=nil )
		assert_select "form", 1 do
			assert_select "label", "Name"
			if pizza&.name
				assert_select "input[type=text][value=?]", pizza.name
			else
				assert_select "input[type=text]"
			end
			assert_select "label", "Vegetarian"
			if pizza&.vegetarian
				assert_select "input[type=checkbox][checked=checked]"
			else
				assert_select "input[type=checkbox]"
			end
			assert_select "label", "Price"
			if pizza&.price
				assert_select "input[type=number][value=?]", pizza.price
			else
				assert_select "input[type=number]"
			end
			assert_select "label", "Calories"
			if pizza&.calories
				assert_select "input[type=number][value=?]", pizza.calories
			else
				assert_select "input[type=number]"
			end
			assert_select "label", "Toppings"
			# One checkbox for each topping and one for the vegetarian field
			assert_select "input[type=checkbox]", toppings.count() + 1
			assert_select "label", toppings(:sausage).name
			if pizza&.toppings&.where(id: toppings(:sausage).id )&.exists?
				assert_select "input[type=checkbox][value=?][checked=checked]", toppings(:sausage).id
			else
				assert_select "input[type=checkbox][value=?]", toppings(:sausage).id
			end
			assert_select "label", toppings(:mushroom).name
			if pizza&.toppings&.where(id: toppings(:mushroom).id )&.exists?
				assert_select "input[type=checkbox][value=?][checked=checked]", toppings(:mushroom).id
			else
				assert_select "input[type=checkbox][value=?]", toppings(:mushroom).id
			end
			assert_select "label", toppings(:green_peppers).name
			if pizza&.toppings&.where(id: toppings(:green_peppers).id )&.exists?
				assert_select "input[type=checkbox][value=?][checked=checked]", toppings(:green_peppers).id
			else
				assert_select "input[type=checkbox][value=?]", toppings(:green_peppers).id
			end
			assert_select "a[href=?]", pizzas_path
		end
	end

end
