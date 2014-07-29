module StaticPagesHelper
  def home_title
    if signed_in?
      current_user.name
    else
      "Welcome to Course Chooser!"
    end
  end
end
