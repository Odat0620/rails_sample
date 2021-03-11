FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.word }
    created_at { Faker::Time.between(from: DateTime.now - 1, to:DateTime.now) }
    association :user
    association :post
  end
end
