class ToppingsController < ApplicationController
  before_action :authorize_store_owner

  def index
    @toppings = Topping.all
  end

  def new
    @topping = Topping.new()
  end

  def create
    @topping = Topping.new(topping_params)
    if @topping.save
      flash[:notice] = "Sucessfully created topping #{@topping.name}"
      redirect_to toppings_path
    else
      flash[:error] = "There was an issue creating the topping: #{@topping.errors.full_messages}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @topping = Topping.find(params[:id])
  end

  def update
    @topping = Topping.find(params[:id])
    if @topping.update(topping_params)
      flash[:notice] = "Sucessfully updated topping #{@topping.name}"
      redirect_to toppings_path
    else
      flash[:error] = "There was an issue updating the topping: #{@topping.errors.full_messages}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @topping = Topping.find(params[:id])
    @topping.destroy()
    flash[:notice] = "Topping deleted"
    redirect_to toppings_path
  end

  private
    def topping_params
      params.require(:topping).permit(:name, :vegetarian, :price, :calories)
    end
end
