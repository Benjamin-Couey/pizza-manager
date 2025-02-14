require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "has_role returns whether user has the provided role" do
    assert users(:owner).has_role(Role::STORE_OWNER)
    assert_not users(:owner).has_role(Role::CHEF)
    assert_not users(:chef).has_role(Role::STORE_OWNER)
    assert users(:chef).has_role(Role::CHEF)
    assert users(:ownerchef).has_role(Role::STORE_OWNER)
    assert users(:ownerchef).has_role(Role::CHEF)
  end
end
