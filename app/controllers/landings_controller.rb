class LandingsController < ApplicationController
  layout "site"
  def home
    set_meta_tags(
      title: "Home Page",
      description: "A basic Landing page.",
      keywords: "Site, rails, booyah"
    )
    @boo = "me"
  end
end