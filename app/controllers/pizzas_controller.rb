class PizzasController < ApplicationController

  before_action :authorize_chef

  def index
    @pizzas = Pizza.all
  end

  def new
    @pizza = Pizza.new()
    @toppings = Topping.all
  end

  def create
    @pizza = Pizza.new(pizza_params)
    if @pizza.save
      flash[:notice] = "Sucessfully created pizza #{@pizza.name}"
      redirect_to pizzas_path
    else
      flash[:error] = "There was an issue creating the pizza: #{@pizza.errors.full_messages}"
      @toppings = Topping.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @pizza = Pizza.find(params[:id])
    @toppings = Topping.all
  end

  def update
    @pizza = Pizza.find(params[:id])
    if @pizza.update(pizza_params)
      flash[:notice] = "Sucessfully updated pizza #{@pizza.name}"
      redirect_to pizzas_path
    else
      flash[:error] = "There was an issue updating the pizza: #{@pizza.errors.full_messages}"
      @toppings = Topping.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pizza = Pizza.find(params[:id])
    @pizza.destroy()
    flash[:notice] = "Pizza deleted"
    redirect_to pizzas_path
  end

  private
    def pizza_params
      params.require(:pizza).permit(:name, :vegetarian, :price, :calories, topping_ids: [])
    end
end
