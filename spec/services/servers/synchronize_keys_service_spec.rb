require 'rails_helper'

describe Servers::SynchronizeKeysService do
  let(:server) { create(:server) }
  let(:user) { create(:user) }
  let(:first_key) { File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_1.pub')).read.strip }
  let(:second_key) { File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_2.pub')).read.strip }
  let(:third_key) { File.open(Rails.root.join('spec', 'fixtures', 'files', 'ed25519_3.pub')).read.strip }
  let(:user_key) { create(:ssh_key, user: user, key: first_key) }
  let(:server_key) do
    key = create(:ssh_key, key: second_key)
    key.servers << server
    key
  end
  let(:conn_mock) { OpenStruct.new(plain_keys: "#{first_key}\n#{third_key}") }

  it 'creates new keys and adds them to server' do
    allow(server).to receive(:conn_service).and_return(conn_mock)
    expect { described_class.new(server).perform }.to(change { SshKey.count }.from(0).to(2))
    expect(SshKey.order(id: :asc).to_a).to eq(server.ssh_keys.order(id: :asc).to_a)
  end

  it 'does nothing when user is already assigned to server' do
    user_key.servers << server
    expect(server.ssh_keys.pluck(:key)).to eq([user_key.key])
    mock = OpenStruct.new(plain_keys: user_key.key)
    allow(server).to receive(:conn_service).and_return(mock)
    expect { described_class.new(server).perform }.not_to(change { SshKey.count })
    expect(server.reload.ssh_keys.pluck(:key)).to eq([user_key.key])
  end

  it 'adds user to server when his key was already present on it' do
    user_key
    expect(server.ssh_keys.pluck(:key)).to eq([])
    expect(server.users.to_a).to eq([])
    mock = OpenStruct.new(plain_keys: user_key.key)
    allow(server).to receive(:conn_service).and_return(mock)
    expect { described_class.new(server).perform }.not_to(change { SshKey.count })
    expect(server.reload.ssh_keys.pluck(:key)).to eq([user_key.key])
    expect(server.users.to_a).to eq([user])
  end

  it 'does nothng if key already belongs to server' do
    server_key
    expect(server.users.count).to eq(0)
    expect(server.ssh_keys.to_a).to eq([server_key])
    mock = OpenStruct.new(plain_keys: second_key)
    allow(server).to receive(:conn_service).and_return(mock)
    expect { described_class.new(server).perform }.not_to(change { SshKey.count })
    expect(server.reload.ssh_keys.to_a).to eq([server_key])
  end

  it 'adds key to server' do
    key = create(:ssh_key, key: third_key, user: nil).reload
    expect(server.users.count).to eq(0)
    expect(server.ssh_keys.count).to eq(0)
    mock = OpenStruct.new(plain_keys: key.key)
    allow(server).to receive(:conn_service).and_return(mock)
    expect { described_class.new(server).perform }.not_to(change { SshKey.count })
    expect(server.reload.ssh_keys.to_a).to eq([key])
  end

  it 'wont re-add user to server when remove_user is set (to user)' do
    user_key
    expect(server.ssh_keys.pluck(:key)).to eq([])
    mock = OpenStruct.new(plain_keys: user_key.key)
    allow(server).to receive(:conn_service).and_return(mock)
    expect { described_class.new(server, removed_user: user).perform }.not_to(change { SshKey.count })
    expect(server.reload.ssh_keys.count).to eq(0)
  end

  it 'wont add key to server when this key is set as removed_key' do
    key = create(:ssh_key, key: third_key, user: nil).reload
    expect(server.users.count).to eq(0)
    expect(server.ssh_keys.count).to eq(0)
    mock = OpenStruct.new(plain_keys: key.key)
    allow(server).to receive(:conn_service).and_return(mock)
    expect { described_class.new(server, removed_key: key).perform }.not_to(change { SshKey.count })
    expect(server.reload.ssh_keys.count).to eq(0)
  end
end
