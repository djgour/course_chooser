FactoryGirl.define do
  factory :user do
    name      "Dave Gee"
    email     "daveg@example.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end