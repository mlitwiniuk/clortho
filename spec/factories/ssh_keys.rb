FactoryBot.define do
  factory :ssh_key do
    association(:user)
    identifier { "MyString" }
    key { "MyText" }
    is_active { true }
  end
end
