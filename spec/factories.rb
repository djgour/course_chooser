FactoryGirl.define do
  factory :user do
    name      "Dave Gee"
    email     "daveg@example.com"
    password  "foobar"
    password_confirmation "foobar"
  end

  factory :courseplan do
    user_id   1
    name      "Default"
  end
  
end