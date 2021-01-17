class SshKeys::SyncWithRemoteCommand
  prepend SimpleCommand
  include ActiveModel::Validations

  def initialize(user)
    @user = user
  end

  def call
    response = HTTP.get(path)
    if response.status.success?
      body = response.body.to_s
      keys = body.split("\n").map(&:strip)
      keys.each do |k|
        @user.ssh_keys.find_or_create_by(key: k)
      end
    else
      errors.add(:base, "#{response.code} #{response.reason}")
    end
  end

  private

  def path
    Settings.keyfile_url_pattern % {USERNAME: @user.username}
  end
end