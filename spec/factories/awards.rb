FactoryBot.define do
  factory :award do
    association :question, factory: :question
    sequence(:name) { |n| "Award name #{n}" }
    image { Rack::Test::UploadedFile.new('spec/fixtures/apple-watch.jpeg', 'image/jpeg') }
  end
end
