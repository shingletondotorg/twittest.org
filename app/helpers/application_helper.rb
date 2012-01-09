module ApplicationHelper
  # Return title on a per-page basis
  def title
    base_title = "Twittest"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  # Logo helper
  def logo
    image_tag("logo.png", :alt => "Twittest")
  end
end
