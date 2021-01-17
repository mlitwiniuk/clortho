# == Schema Information
#
# Table name: ssh_keys
#
#  id         :bigint           not null, primary key
#  identifier :string
#  is_active  :boolean
#  key        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_ssh_keys_on_user_id  (user_id)
#
FactoryBot.define do
  factory :ssh_key do
    user { nil }
    sequence(:key) { |n| "#{n} key" }
    is_active { true }
    trait :with_identifier do
      sequence(:identifier) { |n| "Key #{n}"}
    end
  end
end
