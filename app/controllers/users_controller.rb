class UsersController < ApplicationController
  before_action :require_login

  def update_profile
    if current_user.update(user_params)
      redirect_to dashboard_path, notice: "profile updated!"
    else
      redirect_to dashboard_path, alert: "something went wrong."
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :display_name)
  end
end
