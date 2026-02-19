class HomeController < ApplicationController
  def index
    @campaigns = Campaign.includes(:dm).order(created_at: :desc)
    @suggested_users = logged_in? ? current_user.suggested_users(limit: 6) : []
  end
end
