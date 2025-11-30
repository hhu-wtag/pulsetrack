FactoryBot.define do
  factory :notification do
    association :user
    association :notifiable, factory: :monitored_site

    message { Faker::Lorem.sentence(word_count: 5) }

    read_at { nil }

    trait :read do
      read_at { Time.current }
    end
  end
end
