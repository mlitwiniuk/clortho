require 'sshkit'
require 'sshkit/dsl'

class Servers::ConnService
  include SSHKit::DSL

  def initialize(server)
    @server = server
  end

  def can_connect?
    ret = nil
    on [@server.full_address] do
      ret = capture(:echo, 'can connect')
    end
    ret
  end

  def plain_keys
    ret = nil
    authorized_keys_file = @server.authorized_keys_file
    on [@server.full_address] do
      ret = capture(:cat, "~/.ssh/#{authorized_keys_file}")
    end
    ret
  end

  def update_keys
    keys = @server.plain_keys
    authorized_keys_file = @server.authorized_keys_file
    on [@server.full_address] do
      execute(:echo, "'' > ~/.ssh/authorized_keys_tmp")
      keys.each { |key| execute(:echo, "\"#{key}\" >> ~/.ssh/authorized_keys_tmp") }
      execute(:mv, '~/.ssh/authorized_keys_tmp', "~/.ssh/#{authorized_keys_file}")
    end
  end
end
