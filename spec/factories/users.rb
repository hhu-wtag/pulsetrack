FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "password123" }
  end
end

# spec/factories/monitored_sites.rb
FactoryBot.define do
  factory :monitored_site do
    association :user
    name { Faker::App.name }
    url { Faker::Internet.url }
    check_frequency_seconds { 300 }
    last_status { :pending }
  end
end
