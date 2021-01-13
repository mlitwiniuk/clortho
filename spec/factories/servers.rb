# == Schema Information
#
# Table name: servers
#
#  id         :bigint           not null, primary key
#  host       :string
#  identifier :string
#  port       :integer          default(22)
#  user       :string           default("deploy")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :server do
    identifier { "prograils" }
    host { "prograils.io" }
    port { 22 }
    user { "deploy" }
  end
end
