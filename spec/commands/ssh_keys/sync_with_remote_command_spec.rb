require 'rails_helper'

describe SshKeys::SyncWithRemoteCommand do
  let(:user) { create(:user) }
  let(:fake_key) { File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_2.pub')).read.strip }

  context 'returning (with success) fake key' do
    before { stub_request(:any, "https://github.com/#{user.username}.keys").to_return(body: fake_key) }

    it 'returns with success' do
      result = described_class.call(user)
      expect(result.success?).to eq(true)
    end

    it 'creates new key for an user' do
      expect { described_class.call(user) }.to(change { user.ssh_keys.count })
    end

    it 'wont create new key if its already assigned to different user' do
      create(:ssh_key, key: fake_key, user: create(:user))
      expect { described_class.call(user) }.not_to(change { SshKey.count })
    end

    it 'will reassign key to user if it existed and had no user' do
      key = create(:ssh_key, key: fake_key)
      expect(key.user).to be_blank
      expect { described_class.call(user) }.to(change { user.ssh_keys.count })
      expect(key.reload.user).to eq(user)
    end
  end

  context 'erroring' do
    before { stub_request(:any, "https://github.com/#{user.username}.keys").to_return(status: 404, body: 'nope') }

    it 'does not return with success' do
      result = described_class.call(user)
      expect(result.success?).to eq(false)
    end

    it 'does not create new key for an user' do
      expect { described_class.call(user) }.not_to(change { user.ssh_keys.count })
    end

    it 'has error description' do
      result = described_class.call(user)
      expect(result.errors.full_messages).to eq(['404 Not Found'])
    end
  end
end
