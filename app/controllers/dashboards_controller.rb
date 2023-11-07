class DashboardsController < ApplicationController
  layout "application"
  before_action :authenticate_user!
  def home
    @boo = "me"
    
  end
end