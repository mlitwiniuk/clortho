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
#  user_id    :bigint
#
# Indexes
#
#  index_ssh_keys_on_user_id  (user_id)
#
class SshKey < ApplicationRecord
  ## SCOPES
  ## CONCERNS
  ## CONSTANTS
  ## ATTRIBUTES & RELATED
  ## ASSOCIATIONS
  belongs_to :user, optional: true
  has_and_belongs_to_many :servers
  ## VALIDATIONS
  validates :identifier, presence: true
  validates :key, presence: true, uniqueness: true
  ## CALLBACKS
  before_validation :fill_in_identifier
  ## OTHER

  def to_s
    identifier
  end

  def self.find_by_key(key)
    # TODO: this has to be clever, right now key beginning with give should be enough
    where('key like ?', "#{key}%").first
  end

  private

  ## callback methods

  def fill_in_identifier
    return if identifier.present?

    scope = user.present? ? user.ssh_keys : SshKey.where(user_id: nil)
    last_id = scope.last&.identifier&.split(' ')&.last.to_i
    self.identifier = "Key #{last_id + 1}"
  end
end
