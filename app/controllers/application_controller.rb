class ApplicationController < ActionController::Base
 
  around_action :set_time_zone, if: :current_user
  impersonates :user

  include Pagy::Backend

 
  
  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end  
end
