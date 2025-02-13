class DashboardController < ApplicationController
  def index
    @users = User.all()
  end

  def select
    session[:user_id] = selected_user_params
    flash[:notice] = "Now 'logged in' as the user #{User.find(session[:user_id]).name}"
    redirect_to :root
  end

  private
    def selected_user_params
      params.require(:user_id)
    end
end
