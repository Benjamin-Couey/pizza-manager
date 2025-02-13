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
      redirect_to pizzas_path
    else
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
      redirect_to pizzas_path
    else
      @toppings = Topping.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pizza = Pizza.find(params[:id])
    @pizza.destroy()
    redirect_to pizzas_path
  end

  private
    def pizza_params
      params.require(:pizza).permit(:name, topping_ids: [])
    end
end
