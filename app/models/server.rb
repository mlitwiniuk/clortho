# frozen_string_literal: true

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
class Server < ApplicationRecord
  ## SCOPES
  ## CONCERNS
  ## CONSTANTS
  ## ATTRIBUTES & RELATED
  ## ASSOCIATIONS
  has_and_belongs_to_many :ssh_keys
  has_many :users, -> { distinct }, through: :ssh_keys

  ## VALIDATIONS
  validates :host, :identifier, :user, :authorized_keys_file, presence: true
  validates :port, presence: true, numericality: { only_integer: true, greater_than: 0 }

  ## CALLBACKS
  ## OTHER

  def to_s
    "#{identifier} (#{full_address})"
  end

  def full_address
    "#{user}@#{host}:#{port}"
  end

  def conn_service
    Servers::ConnService.new(self)
  end

  def plain_keys
    user_keys = users.map(&:ssh_keys).flatten
    (user_keys | ssh_keys.to_a).uniq.map(&:key).flatten
  end

  private

  ## callback methods
end
