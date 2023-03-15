# == Schema Information
#
# Table name: ssh_keys
#
#  id          :bigint           not null, primary key
#  fingerprint :string
#  identifier  :string
#  is_active   :boolean
#  key         :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_ssh_keys_on_fingerprint  (fingerprint) UNIQUE
#  index_ssh_keys_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :ssh_key do
    user { nil }
    key { File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_1.pub')).read }
    is_active { true }
    trait :with_identifier do
      sequence(:identifier) { |n| "Key #{n}" }
    end
    trait :second do
      key { File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_2.pub')).read }
    end
    trait :third do
      key { File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_3.pub')).read }
    end
    trait :rsa1024 do
      key { File.open(Rails.root.join('spec', 'fixtures', 'files', 'rsa_1024.pub')).read }
    end
    trait :rsa2048 do
      key { File.open(Rails.root.join('spec', 'fixtures', 'files', 'rsa_2048.pub')).read }
    end
    trait :rsa4096 do
      key { File.open(Rails.root.join('spec', 'fixtures', 'files', 'rsa4096.pub')).read }
    end
    trait :third do
      key { File.open(Rails.root.join('spec', 'fixtures', 'files', 'id_25519_1.pub')).read }
    end
  end
end
