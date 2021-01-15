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
    on [@server.full_address] do
      ret = capture(:cat, '~/.ssh/authorized_keys')
    end
    ret
  end
end
