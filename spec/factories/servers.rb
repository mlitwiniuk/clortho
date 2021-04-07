# == Schema Information
#
# Table name: servers
#
#  id                   :bigint           not null, primary key
#  authorized_keys_file :string           default("authorized_keys")
#  host                 :string
#  identifier           :string
#  last_synchronized_at :datetime
#  port                 :integer          default(22)
#  user                 :string           default("deploy")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
FactoryBot.define do
  factory :server do
    identifier { 'prograils' }
    host { 'prograils.io' }
    port { 22 }
    user { 'deploy' }
    authorized_keys_file { 'authorized_keys' }
  end
end
