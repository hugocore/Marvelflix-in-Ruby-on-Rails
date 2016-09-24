FactoryGirl.define do
  factory :character do
    name { FFaker::Name.name }
  end
end
