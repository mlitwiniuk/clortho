class Servers::SynchronizeKeysService
  def initialize(server)
    @server = server
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
      ssh_key = SshKey.find_or_create_by(key: k)
      next if ssh_key.servers.member?(@server)

      @server.ssh_keys << ssh_key
    end
  end

  def upload_keys
    @server.conn_service.update_keys
  end
end
