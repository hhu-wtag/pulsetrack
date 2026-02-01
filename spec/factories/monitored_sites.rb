FactoryBot.define do
  factory :monitored_site do
    association :team
    name { Faker::App.name }
    url { Faker::Internet.url }
    check_frequency_seconds { 300 }
    last_status { :pending }
  end
end
