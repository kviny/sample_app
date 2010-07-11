class PagesController < ApplicationController
  def contact
    @title = "Contact"
  end

  def home
    @title = "Home"
  end

  def about
    @title = "About"
  end
end
