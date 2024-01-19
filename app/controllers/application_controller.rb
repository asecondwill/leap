class ApplicationController < ActionController::Base
 
  around_action :set_time_zone, if: :current_user
  impersonates :user

  include Pagy::Backend

  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
 
  
  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end  
end
