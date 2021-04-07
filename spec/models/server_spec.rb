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
require 'rails_helper'

RSpec.describe Server, type: :model do
  it { is_expected.to have_and_belong_to_many(:ssh_keys) }
  it { is_expected.to have_many(:users) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:host) }
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_presence_of(:port) }
    it { is_expected.to validate_numericality_of(:port).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:authorized_keys_file) }
  end

  let(:server) { create(:server) }
  describe '.full_address' do
    it 'returns full address' do
      expect(server.full_address).to eq('deploy@prograils.io:22')
    end
  end

  describe '.plain_keys' do
    let(:user) { create(:user) }

    it 'returns array of keys' do
      user_key = create(:ssh_key, user: user)
      server.ssh_keys << user_key
      server_key = create(:ssh_key, :second, user: nil)
      server.ssh_keys << server_key
      key_not_added_directly = create(:ssh_key, :rsa1024, user: user)
      a = [user_key.key, server_key.key, key_not_added_directly.key]
      expect(server.plain_keys).to contain_exactly(*a)
    end
  end
end
