# frozen_string_literal: true

class SshKey < ApplicationRecord
  ## SCOPES
  ## CONCERNS
  ## CONSTANTS
  ## ATTRIBUTES & RELATED
  ## ASSOCIATIONS
  belongs_to :user
  ## VALIDATIONS
  validates :key, presence: true, uniqueness: true
  ## CALLBACKS
  ## OTHER

  private

  ## callback methods
end

