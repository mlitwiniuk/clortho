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
#  user_id    :bigint           not null
#
# Indexes
#
#  index_ssh_keys_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe SshKey, type: :model do
  let(:user) { create(:user) }

  it { is_expected.to belong_to(:user) }

  describe "validations" do
    subject { build(:ssh_key, user: user) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_uniqueness_of(:key) }
  end

  describe '.fill_in_identifier' do
    it "fills in identifier if it's blank" do
      key = build(:ssh_key, user: user)
      expect(key.identifier).to be_blank
      key.valid?
      expect(key).to be_valid
      expect(key.identifier).to eq('Key 1')
    end
  end
end
