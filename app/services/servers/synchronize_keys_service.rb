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
      ssh_key = SshKey.find_by_key(k)
      if ssh_key
        if ssh_key.user.present?
          next if ssh_key.user.servers.member?(@server)

          @server.users << ssh_key.user
        else
          next if ssh_key.servers.member?(@server)

          @server.ssh_keys << ssh_key
        end
      else
        ssh_key = SshKey.create!(key: k)
        ssh_key.servers << @server
      end
    end
  end

  def upload_keys
    @server.conn_service.update_keys
  end
end
