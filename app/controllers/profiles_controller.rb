class ProfilesController < ApplicationController
  before_action :require_login

  def update
    if current_user.update(profile_params)
      redirect_to root_path, notice: "Profile updated."
    else
      redirect_to root_path, alert: current_user.errors.full_messages.to_sentence
    end
  end

  private

  def require_login
    redirect_to root_path, alert: "Please log in." unless logged_in?
  end

  def profile_params
    params.require(:user).permit(
      :experience_level,
      :dm_experience,
      :email_notifications,
      roles: [],
      styles: [],
      atmospheres: [],
      availability: {}
    )
  end
end
