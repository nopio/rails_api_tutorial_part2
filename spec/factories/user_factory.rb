FactoryGirl.define do
  factory :user do
    first_name 'Dummy'
    last_name 'User'
    sequence(:email) { |i| "dummy.user-#{i}@gmail.com" }
  end
end
