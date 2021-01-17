# frozen_string_literal: true

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
class Server < ApplicationRecord
  ## SCOPES
  ## CONCERNS
  ## CONSTANTS
  ## ATTRIBUTES & RELATED
  ## ASSOCIATIONS
  has_and_belongs_to_many :ssh_keys
  has_and_belongs_to_many :users
  has_many :user_keys, class_name: 'SshKey', through: :users, source: :ssh_keys

  ## VALIDATIONS
  validates :host, :identifier, :user,
            presence: true
  validates :port,
            presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  ## CALLBACKS
  ## OTHER

  def full_address
    "#{user}@#{host}:#{port}"
  end

  def conn_service
    Servers::ConnService.new(self)
  end

  def plain_keys
    user_keys.pluck(:key) | ssh_keys.pluck(:key)
  end

  private

  ## callback methods
end
