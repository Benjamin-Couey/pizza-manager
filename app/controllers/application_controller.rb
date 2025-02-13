class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :current_user

  def user_from_session
    return User.find_by(id: session[:user_id])
  end

  def current_user
    @current_user = user_from_session()
  end

  def authorize_store_owner
    flash[:error] = "Only store owners may access that page"
    redirect_to :root unless user_from_session()&.has_role(Role::STORE_OWNER)
  end

  def authorize_chef
    flash[:error] = "Only chefs may access that page"
    redirect_to :root unless user_from_session()&.has_role(Role::CHEF)
  end

end
