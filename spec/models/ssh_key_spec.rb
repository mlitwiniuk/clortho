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
require 'rails_helper'

RSpec.describe SshKey, type: :model do
  let(:user) { create(:user) }

  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to have_and_belong_to_many(:servers) }

  describe 'validations' do
    subject { build(:ssh_key, user: user) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to validate_uniqueness_of(:key) }
  end

  describe '.to_s' do
    it 'return identifier' do
      key = create(:ssh_key)
      expect(key.to_s).to eq(key.identifier)
    end
  end

  describe '#find_by_pub_key' do
    it 'properly finds key' do
      k = create(:ssh_key, key: 'foo_bar')
      expect(SshKey.find_by_key('foo')).to eq(k)
    end

    it 'splits key and takes first two parts to find it' do
      k = create(:ssh_key, key: 'foo bar bak')
      expect(SshKey.find_by_key('foo bar baz')).to eq(k)
    end
  end

  describe '.fill_in_identifier' do
    it "fills in identifier if it's blank" do
      key = build(:ssh_key, user: user)
      expect(key.identifier).to be_blank
      key.valid?
      expect(key).to be_valid
      expect(key.identifier).to eq('Key 1')
    end

    it 'avoid same names' do
      first = create(:ssh_key, user: user)
      second = create(:ssh_key, user: user)
      expect(second.identifier).to eq('Key 2')
      first.destroy
      third = create(:ssh_key, user: user)
      expect(third.identifier).to eq('Key 3')
      third.destroy
      fourth = create(:ssh_key, user: user)
      expect(fourth.identifier).to eq('Key 3')
    end
  end
end
