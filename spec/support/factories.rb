FactoryGirl.define do
  sequence(:name) { |n| "Name #{n}" }
  sequence(:email) { |n| "email#{n}@example.com" }

  factory :group do
    name
  end

  factory :person do
    email
  end
end
