class LandingsController < ApplicationController
  layout "site"
  def home
    @boo = "me"
  end
end