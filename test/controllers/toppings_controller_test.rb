require "test_helper"

class ToppingsControllerPermissionsTest < ActionDispatch::IntegrationTest
  test "toppings controller redirects non store owners to root" do
    get toppings_path
    assert_redirected_to root_path
    assert_equal "Only store owners may access that page", flash[:error]

    sign_in_as users(:chef)
    get edit_topping_path(toppings(:sausage).id)
    assert_redirected_to root_path
    assert_equal "Only store owners may access that page", flash[:error]

    post toppings_path, params: { topping: { name: "New topping" } }
    assert_redirected_to root_path
    assert_equal "Only store owners may access that page", flash[:error]
  end
end

class ToppingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:owner)
  end

  test "toppings index action" do
    get toppings_path
    assert_response :success
  end

  test "toppings new action" do
    get new_topping_path
    assert_response :success
  end

  test "toppings create action" do
    num_toppings = Topping.all().count
    post toppings_path, params: { topping: { name: "New topping" } }
    assert_redirected_to toppings_path
    assert_equal "Sucessfully created topping New topping", flash[:notice]
    assert_equal num_toppings + 1, Topping.all().count
  end

  test "toppings edit action" do
    get edit_topping_path(toppings(:sausage).id)
    assert_response :success
  end

  test "toppings update action" do
    patch topping_path(toppings(:sausage).id), params: { topping: { name: "Italian Sausage" } }
    assert_redirected_to toppings_path
    assert_equal "Sucessfully updated topping Italian Sausage", flash[:notice]
    assert_equal "Italian Sausage", Topping.find_by(id: toppings(:sausage).id).name
  end

  test "toppings destroy action" do
    num_toppings = Topping.all().count
    delete topping_path(toppings(:sausage).id)
    assert_redirected_to toppings_path
    assert_equal "Topping deleted", flash[:notice]
    assert_equal num_toppings - 1, Topping.all().count
  end
end
