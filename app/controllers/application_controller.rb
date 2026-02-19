class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?
  before_action :ensure_onboarding, if: :logged_in?

  private

  def current_user
    return nil unless session[:user_id]

    user = User.find_by(id: session[:user_id])
    return user if user.is_a?(User)

    reset_session
    nil
  end

  def logged_in?
    current_user.present?
  end

  def ensure_onboarding
    return if current_user.prefs_complete?
    return if controller_name.in?(%w[sessions onboarding profiles]) && action_name.in?(%w[new callback destroy index update])
    return if request.path.start_with?("/rails/active_storage")

    redirect_to onboarding_path
  end
end
