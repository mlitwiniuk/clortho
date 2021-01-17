require 'rails_helper'

describe Servers::SynchronizeKeysService do
  let(:server) { create(:server) }
  let(:user) { create(:user) }
  let(:user_key) { create(:ssh_key, user: user, key: 'test')}
  let(:server_key) do
    key = create(:ssh_key, key: 'other_test')
    key.servers << server
    key
  end
  let(:conn_mock) do
    OpenStruct.new(plain_keys: "test\ntest2")
  end

  it 'creates new keys and adds them to server' do
    allow(server).to receive(:conn_service).and_return(conn_mock)
    expect{
      described_class.new(server).perform
    }.to change {SshKey.count}.from(0).to(2)
    expect(SshKey.order(id: :asc).to_a).to eq(server.ssh_keys.order(id: :asc).to_a)
  end

  it 'does nothing when user is already assigned to server' do
    user_key
    user.servers << server
    expect(server.user_keys.pluck(:key)).to eq(['test'])
    expect(server.ssh_keys.pluck(:key)).to eq([])
    mock = OpenStruct.new(plain_keys: 'test')
    allow(server).to receive(:conn_service).and_return(mock)
    expect{
      described_class.new(server).perform
    }.not_to change{ SshKey.count}
    expect(server.user_keys.pluck(:key)).to eq(['test'])
    expect(server.ssh_keys.pluck(:key)).to eq([])
  end

  it 'adds user to server when his key was already present on it' do
    user_key
    expect(server.user_keys.pluck(:key)).to eq([])
    expect(server.ssh_keys.pluck(:key)).to eq([])
    expect(server.users.to_a).to eq([])
    mock = OpenStruct.new(plain_keys: 'test')
    allow(server).to receive(:conn_service).and_return(mock)
    expect{
      described_class.new(server).perform
    }.not_to change{ SshKey.count}
    expect(server.users.to_a).to eq([user])
    expect(server.user_keys.pluck(:key)).to eq(['test'])
  end

  it 'does nothng if key already belongs to server' do
    server_key
    expect(server.users.count).to eq(0)
    expect(server.ssh_keys.to_a).to eq([server_key])
    mock = OpenStruct.new(plain_keys: 'other_test')
    allow(server).to receive(:conn_service).and_return(mock)
    expect{
      described_class.new(server).perform
    }.not_to change{ SshKey.count}
    expect(server.ssh_keys.to_a).to eq([server_key])
  end

  it 'adds key to server' do
    key = create(:ssh_key, key: 'other_test', user: nil).reload
    expect(server.users.count).to eq(0)
    expect(server.ssh_keys.count).to eq(0)
    mock = OpenStruct.new(plain_keys: key.key)
    allow(server).to receive(:conn_service).and_return(mock)
    expect{
      described_class.new(server).perform
    }.not_to change{ SshKey.count}
    expect(server.ssh_keys.to_a).to eq([key])
  end
end
