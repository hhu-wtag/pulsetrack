FactoryBot.define do
  factory :check_result do
    association :monitored_site
    status { :up }
  end
end
