FactoryGirl.define do
  sequence(:name) { |n| "Name #{n}" }
  sequence(:email) { |n| "email#{n}@example.com" }

  factory :group do
    name
  end

  factory :person do
    email
  end

  factory :group_membership do
    sequence(:group_id)
    sequence(:person_id)
  end
end
