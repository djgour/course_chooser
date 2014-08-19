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
  
  
  factory :course do
    name    "Learning Rails"
    code    "RLS7777H"
    description "Learn how to use Ruby on Rails to create online information systems."
  end
end