require "test_helper"

class ToppingTest < ActiveSupport::TestCase
  test "should not allow duplicate toppings" do
    dupTopping = Topping.new(name: toppings(:sausage).name)
    assert_not dupTopping.valid?
  end
end
