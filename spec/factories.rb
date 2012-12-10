FactoryGirl.define do
  factory :user do
    name                    "Paul Bonneau"
    email                   "pbonneau@groupon.com"
    password                "foobar"
    password_confirmation   "foobar"
  end
end
