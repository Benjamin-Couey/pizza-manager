require "test_helper"

class ToppingsIntegrationTest < ActionDispatch::IntegrationTest

	setup do
		sign_in_as users(:owner)
	end

	test "visit toppings page and see table of toppings" do
		get toppings_path
		assert_response :success
		assert_select "h1", "Toppings"
		assert_select "tbody tr", toppings.count()
		assert_select "tbody tr td", toppings(:sausage).name
		assert_select "tbody tr td a[href=?]", edit_topping_path(toppings(:sausage).id)
		assert_select "tbody tr td form[action=?]", topping_path(toppings(:sausage).id) do
			assert_select "button", "Delete"
		end
		assert_select "tbody tr td", toppings(:mushroom).name
	end

	test "visit toppings page and create a new topping" do
		get toppings_path
		assert_response :success

		get new_topping_path
		assert_response :success
		assert_one_toppings_form_present
		assert_select "form input[value=?]", "Create Topping"

		post toppings_path, params: { topping: { name: "New topping", vegetarian: false, price: 10.5, calories: 100 } }
		assert_redirected_to toppings_path
		follow_redirect!
		assert_select "tbody tr td", "New topping"
		assert_select "tbody tr td", "10.5"
		assert_select "tbody tr td", "100"

		post toppings_path, params: { topping: { name: toppings(:sausage).name, vegetarian: false, price: 10.5, calories: 100 } }
		assert_response :unprocessable_entity
		assert_select "div", "There was an issue creating the topping: [\"Name has already been taken\"]"
	end

	test "visit toppings page and update a topping" do
		get toppings_path
		assert_response :success

		get edit_topping_path(toppings(:sausage).id)
		assert_response :success
		assert_one_toppings_form_present( toppings(:sausage) )
		assert_select "form input[value=?]", "Update Topping"

		patch topping_path(toppings(:sausage).id), params: { topping: { name: "Italian Sausage", price: 10.5, calories: 100 } }
		assert_redirected_to toppings_path
		follow_redirect!
		assert_select "tbody tr td", "Italian Sausage"
		assert_select "tbody tr td", "10.5"
		assert_select "tbody tr td", "100"
		assert_select "tbody tr td", {count: 0, text: toppings(:sausage).name}


		patch topping_path(toppings(:sausage).id), params: { topping: { name: toppings(:mushroom).name, price: 10.5, calories: 100 } }
		assert_response :unprocessable_entity
		assert_select "div", "There was an issue updating the topping: [\"Name has already been taken\"]"
	end

	test "visit toppings page and delete a topping" do
		get toppings_path
		assert_response :success

		delete topping_path(toppings(:sausage).id)
		assert_redirected_to toppings_path
		follow_redirect!
		assert_select "tbody tr td", {count: 0, text: toppings(:sausage).name}
	end

	private

	def assert_one_toppings_form_present( topping=nil )
		assert_select "form", 1 do
			assert_select "label", "Name"
			if topping&.name
				assert_select "input[type=text][value=?]", topping.name
			else
				assert_select "input[type=text]"
			end
			assert_select "label", "Vegetarian"
			if topping&.vegetarian
				assert_select "input[type=checkbox][checked=checked]"
			else
				assert_select "input[type=checkbox]"
			end
			assert_select "label", "Price"
			if topping&.price
				assert_select "input[type=number][value=?]", topping.price
			else
				assert_select "input[type=number]"
			end
			assert_select "label", "Calories"
			if topping&.calories
				assert_select "input[type=number][value=?]", topping.calories
			else
				assert_select "input[type=number]"
			end
		end
	end

end
