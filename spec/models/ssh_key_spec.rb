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
      k = create(:ssh_key, :second)
      key = File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_2.pub')).read
      expect(SshKey.find_by_key(key)).to eq(k)
    end

    it 'splits key and takes first two parts to find it' do
      k = create(:ssh_key, :second)
      key = File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_2.pub')).read.strip
      expect(SshKey.find_by_key("#{key} some comment")).to eq(k)
    end
  end

  describe '.calculate_fingerprint' do
    it 'fills in calculated key fingerprint upon validation' do
      key = File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_2.pub')).read.strip
      ssh_key = SshKey.new(key: key)
      expect(ssh_key).to be_valid
      expect(ssh_key.fingerprint).to be_present
    end

    it 'will create an error when key is invalid' do
      ssh_key = SshKey.new(key: 'foo bar')
      expect(ssh_key).not_to be_valid
      expect(ssh_key.fingerprint).not_to be
      expect(ssh_key.errors.attribute_names).to eq([:key])
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

    it "fills in identifier if it's blank and user is missing" do
      key = build(:ssh_key, user: nil)
      expect(key.identifier).to be_blank
      key.valid?
      expect(key).to be_valid
      expect(key.identifier).to eq('Anonymous Key 1')
    end

    it "renames key when it's assigned to user" do
      key = build(:ssh_key, user: nil)
      key.save
      expect(key.identifier).to eq('Anonymous Key 1')
      key.update(user: user)
      expect(key.reload.identifier).to eq('Key 1')
    end

    it 'avoid same names' do
      first = create(:ssh_key, user: user)
      second = create(:ssh_key, :second, user: user)
      expect(second.identifier).to eq('Key 2')
      first.destroy
      third = create(:ssh_key, :third, user: user)
      expect(third.identifier).to eq('Key 3')
      third.destroy
      fourth = create(:ssh_key, :rsa1024, user: user)
      expect(fourth.identifier).to eq('Key 3')
    end
  end
end
