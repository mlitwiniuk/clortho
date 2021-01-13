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

  private

  ## callback methods
end

