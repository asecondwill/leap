class ApplicationController < ActionController::Base
  before_action :set_current_user  
  # around_action :set_time_zone, if: :current_user

  include Pagy::Backend

  def set_current_user
    # TODO: Devise used to do this, is something borked?
    @current_user = current_user if current_user
  end
  
  # def set_time_zone(&block)
  #   Time.use_zone(current_user.time_zone, &block)
  # end  
end
