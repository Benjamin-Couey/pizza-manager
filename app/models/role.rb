class Role < ApplicationRecord

	has_and_belongs_to_many :users

	STORE_OWNER = "Store Owner"
	CHEF = "Chef"

end
