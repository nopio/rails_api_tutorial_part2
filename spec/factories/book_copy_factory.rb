FactoryGirl.define do
  factory :book_copy do
    sequence(:isbn) { |i| "0000#{i}" }
    format 'hardback'
    published Date.today - 5.years
    association(:book)
  end
end
