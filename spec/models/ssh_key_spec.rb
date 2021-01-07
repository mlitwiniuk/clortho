require 'rails_helper'

RSpec.describe SshKey, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_uniqueness_of(:key) }
end
