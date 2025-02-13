class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :current_user

  def current_user
    @current_user = User.find(session[:user_id])
  end

  def authorize_store_owner
    redirect_to :root unless User.find(session[:user_id]).has_role(Role::STORE_OWNER)
  end

  def authorize_chef
    redirect_to :root unless User.find(session[:user_id]).has_role(Role::CHEF)
  end

end
