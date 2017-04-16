FactoryGirl.define do
  factory :admin, class: 'User' do
    admin true
    first_name 'Piotr'
    last_name 'Jaworski'
    sequence(:email) { |i| "piotrek.jaw-#{i}@gmail.com" }
  end
end
