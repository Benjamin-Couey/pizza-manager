class Pizza < ApplicationRecord

	has_and_belongs_to_many :toppings

	validates :name, uniqueness: { case_sensitive: false }
	validate :unique_toppings_combination

	def unique_toppings_combination
		# TODO: Figure out a decent way to handle this
	end

end
