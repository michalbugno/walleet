FactoryGirl.define do
  sequence(:name) { |n| "Name #{n}" }
  factory :group do
    name
  end
end
