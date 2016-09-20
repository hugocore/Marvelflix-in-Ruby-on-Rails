FactoryGirl.define do
  factory :upvote do
    user
    comic_id { FFaker::Guid.guid }
  end
end
