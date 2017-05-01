FactoryGirl.define do
  factory :book do
    association(:author)
    sequence(:title) { |i| "Book #{i}" }
  end
end
