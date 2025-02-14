class Pizza < ApplicationRecord
  has_and_belongs_to_many :toppings

  validates :name, uniqueness: { case_sensitive: false }
  validate :unique_toppings_combination

  def is_vegetarian
    toppings.all?(&:vegetarian) && vegetarian
  end

  def numeric_total(attribute)
    sum = self[attribute]
    if !sum.is_a? Numeric
      return nil
    end
    toppings.each do |topping|
      sum += topping[attribute]
    end
    sum
  end

  private

  def unique_toppings_combination
    # TODO: Find more performant implementation
    # TODO: Update to also make sure pizzas have same vegetarian, calories, price
    Pizza.where.not(id: id).each do |pizza|
      if pizza.toppings.sort == toppings.sort
        errors.add(:toppings, "are a combination already in use by the pizza #{pizza.name}")
      end
    end
  end
end
