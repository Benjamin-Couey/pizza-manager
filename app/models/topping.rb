class Topping < ApplicationRecord

	has_and_belongs_to_many :pizzas

	validates :name, uniqueness: { case_sensitive: false }

end
