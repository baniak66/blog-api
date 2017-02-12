FactoryGirl.define do
  factory :article do
    title Faker::Lorem.sentence
    content Faker::Lorem.paragraph
  end
end
