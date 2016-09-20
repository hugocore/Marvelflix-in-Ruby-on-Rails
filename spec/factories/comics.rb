FactoryGirl.define do
  factory :comic do
    id { FFaker::Guid.guid }
  end
end
