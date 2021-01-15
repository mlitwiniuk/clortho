# frozen_string_literal: true

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
class SshKey < ApplicationRecord
  ## SCOPES
  ## CONCERNS
  ## CONSTANTS
  ## ATTRIBUTES & RELATED
  ## ASSOCIATIONS
  belongs_to :user
  ## VALIDATIONS
  validates :identifier, presence: true
  validates :key, presence: true, uniqueness: true
  ## CALLBACKS
  before_validation :fill_in_identifier
  ## OTHER

  def to_s
    identifier
  end

  private

  ## callback methods

  def fill_in_identifier
    return if identifier.present?
    return unless user.present?

    last_id = owner.ssh_keys.last&.identifier&.split(' ')&.last.to_i
    self.identifier = "#{owner_type} Key #{last_id + 1}"
  end
end
