require 'rails_helper'

describe SshKeys::SyncWithRemoteCommand do
  let(:user) { create(:user) }
  let(:fake_key) { "a key" }

  context 'returning (with success) fake key' do
    before do
      stub_request(:any, "https://github.com/#{user.username}.keys").to_return(body: fake_key)
    end
    it 'returns with success' do
      result = described_class.call(user)
      expect(result.success?).to eq(true)
    end

    it 'creates new key for an user' do
      expect{
        result = described_class.call(user)
      }.to change { user.ssh_keys.count }
    end
  end
  context 'erroring' do
    before do
      stub_request(:any, "https://github.com/#{user.username}.keys").to_return(status: 404, body: 'nope')
    end

    it 'does not return with success' do
      result = described_class.call(user)
      expect(result.success?).to eq(false)
    end

    it 'does not create new key for an user' do
      expect{
        result = described_class.call(user)
      }.not_to change { user.ssh_keys.count }
    end

    it 'has error description' do
      result = described_class.call(user)
      expect(result.errors.full_messages).to eq(["404 Not Found"])
    end
  end
end
