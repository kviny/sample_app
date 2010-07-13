# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    if @title.nil?
      "Ruby on Rails Tutorial Sample App"
    else
      "Ruby on Rails Tutorial Sample App | #{@title}"
    end
  end
end

