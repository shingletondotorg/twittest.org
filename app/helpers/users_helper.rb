module UsersHelper
  def gravatar_for(user, options = { :size => 50 })
    # Gravatars are square, so setting :size sets the height and width
    gravatar_image_tag(user.email, :alt => user.name,
                                   :class => "gravatar",
                                   :gravatar => options)
  end
end
