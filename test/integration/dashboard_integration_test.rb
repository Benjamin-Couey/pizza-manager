require "test_helper"

class DashboardIntegrationTest < ActionDispatch::IntegrationTest

	test "visit dashboard and see table of users" do
		get root_path
		assert_response :success
		assert_select "h1", "Test Dashboard"
		assert_select "tbody tr", users.count()
		assert_select "tbody tr td", users(:owner).name
		assert_select "tbody tr td form" do
			assert_select "button", "Select"
			assert_select "input[type=hidden][name=user_id][value=?]", users(:owner).id
		end
		assert_select "tbody tr td", users(:chef).name
		assert_select "tbody tr td", users(:ownerchef).name
	end

	test "visit dashboard and select users" do
		get root_path
		assert_response :success

		post root_path, params: { user_id: users(:owner).id }
		assert_redirected_to root_path
		follow_redirect!
		assert_select "div", "Using user #{users(:owner).name}"
		assert_select "a[href=?]", "/toppings", "Manage toppings"
		assert_select "a[href=?]", "/pizzas", false

		post root_path, params: { user_id: users(:chef).id }
		assert_redirected_to root_path
		follow_redirect!
		assert_select "div", "Using user #{users(:chef).name}"
		assert_select "a[href=?]", "/toppings", false
		assert_select "a[href=?]", "/pizzas", "Manage pizzas"

		post root_path, params: { user_id: users(:ownerchef).id }
		assert_redirected_to root_path
		follow_redirect!
		assert_select "div", "Using user #{users(:ownerchef).name}"
		assert_select "a[href=?]", "/toppings", "Manage toppings"
		assert_select "a[href=?]", "/pizzas", "Manage pizzas"
	end

end
