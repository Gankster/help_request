FactoryBot.define do
  factory :question do
    title { "MyTitle" }
    body { "MyText" }

    trait :invalid do
      title { '' }
      body { nil }
    end
  end
end
