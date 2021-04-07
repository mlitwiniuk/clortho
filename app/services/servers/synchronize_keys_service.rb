class Servers::SynchronizeKeysService
  def initialize(server, removed_user: nil, removed_key: nil)
    @server = server
    @removed_user = removed_user
    @removed_key = removed_key
    @keys = []
  end

  def perform
    fetch_existing_keys
    create_missing_keys
    upload_keys
  end

  def fetch_existing_keys
    @keys = @server.conn_service.plain_keys.split("\n")
  end

  def create_missing_keys
    @keys.each do |k|
      k = k.strip
      next if k.blank?

      ssh_key = SshKey.find_or_create_by_key(k)

      # skip if key is already assigned to server
      next if ssh_key.servers.member?(@server)

      # skip if fingerprint is same as one removed from server
      next if ssh_key.fingerprint == @removed_key&.fingerprint

      # skip if key belongs to user removed from server
      next if @removed_user && ssh_key.user == @removed_user

      # otherwise add key to server
      @server.ssh_keys << ssh_key
    end
  end

  def upload_keys
    @server.conn_service.update_keys
  end
end
