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
require 'rails_helper'

RSpec.describe Server, type: :model do
  it { is_expected.to have_and_belong_to_many(:ssh_keys) }
  it { is_expected.to have_and_belong_to_many(:users) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:host) }
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_presence_of(:port) }
    it { is_expected.to validate_numericality_of(:port).only_integer.is_greater_than(0) }
    it { is_expected.to validate_presence_of(:user) }
  end

  let(:server) { create(:server) }
  it 'returns full address' do
    expect(server.full_address).to eq('deploy@prograils.io:22')
  end
end
