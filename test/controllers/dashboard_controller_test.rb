require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest

	test "dashboard index action" do
		get root_path
		assert_response :success
	end

	test "dashboard select action" do
		post root_path, params: { user_id: users(:owner).id }
		assert_redirected_to root_path
		assert_equal "Now 'logged in' as the user #{users(:owner).name}", flash[:notice]
	end

end
