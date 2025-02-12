class Pizza < ApplicationRecord

	has_and_belongs_to_many :toppings

	validates :name, uniqueness: { case_sensitive: false }
	validate :unique_toppings_combination

	def unique_toppings_combination
		Pizza.all().each do |pizza|
			if pizza.toppings.sort == toppings.sort
				errors.add(:toppings, 'this combination of toppings is already used')
			end
		end
	end

end
