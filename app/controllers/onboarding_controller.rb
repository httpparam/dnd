class OnboardingController < ApplicationController
  before_action :require_login

  def index
  end

  private

  def require_login
    redirect_to root_path, alert: "Please log in." unless logged_in?
  end
end
