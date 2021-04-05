# frozen_string_literal: true

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
  before_validation :calculate_fingerprint

  ## OTHER

  def to_s
    identifier
  end

  def self.find_by_key(key)
    fingerprint = ::SSHKey.fingerprint key
    find_by(fingerprint: fingerprint)
  end

  def self.find_or_initialize_by_key(key)
    k = find_by_key(key)
    return k if k

    new(key: key)
  end

  def self.find_or_create_by_key(key)
    k = find_by_key(key)
    return k if k

    create(key: key)
  end

  private

  ## callback methods

  def calculate_fingerprint
    return unless key.present?
    return unless key_changed?

    self.fingerprint = ::SSHKey.fingerprint key
  rescue ::SSHKey::PublicKeyError => e
    errors.add(:key, e.to_s)
  end

  def fill_in_identifier
    return if identifier.present?

    scope = user.present? ? user.ssh_keys : SshKey.where(user_id: nil)
    last_id = scope.last&.identifier&.split(' ')&.last.to_i
    self.identifier = "Key #{last_id + 1}"
  end
end
