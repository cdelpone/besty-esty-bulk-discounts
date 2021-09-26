FactoryBot.define do
  factory :bulk_discount, class: BulkDiscount do
    association :merchant
    quantity { Faker::Number.within(range: 1..1000) }
    percentage { Faker::Decimal.within(range: 0..1) }
    id { Faker::Number.unique.within(range: 1..1_000_000) }
  end
end
