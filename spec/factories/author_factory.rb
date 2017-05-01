FactoryGirl.define do
  factory :author do
    first_name 'Dummy'
    sequence(:last_name) { |i| "Author #{i}" }
  end
end
