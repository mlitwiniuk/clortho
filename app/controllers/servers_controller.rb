class ServersController < ApplicationController
  before_action :set_server, except: %i[index new create]

  # GET /servers
  def index
    @servers = Server.all
  end

  # GET /servers/1
  def show
    @available_users = User.where.not(id: @server.user_ids)
  end

  # GET /servers/new
  def new
    @server = Server.new
  end

  # GET /servers/1/edit
  def edit; end

  # POST /servers
  def create
    @server = Server.new(server_params)

    if @server.save
      redirect_to @server, notice: 'Server was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /servers/1
  def update
    if @server.update(server_params)
      redirect_to @server, notice: 'Server was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /servers/1
  def destroy
    @server.destroy
    redirect_to servers_url, notice: 'Server was successfully destroyed.'
  end

  def resync
    # TODO: move to background job
    Servers::SynchronizeKeysService.new(@server).perform

    # TODO: active channel!!!
    redirect_to @server, notice: 'Resync done'
  end

  def remove_key
    ssh_key = SshKey.find(params[:ssh_key_id])
    @server.ssh_keys.destroy(ssh_key)
    Servers::SynchronizeKeysService.new(@server, removed_key: ssh_key).perform
    redirect_to @server, notice: 'SSH Key successfully removed from server.'
  end

  def remove_user
    user = User.find(params[:user_id])
    @server.ssh_keys.destroy(user.ssh_keys.to_a)
    Servers::SynchronizeKeysService.new(@server, removed_user: user).perform
    redirect_to @server, notice: 'User successfully removed from server.'
  end

  def add_user
    redirect_to @server && return unless params[:user_id].present?

    user = User.find(params[:user_id])
    @server.ssh_keys << user.ssh_keys
    Servers::SynchronizeKeysService.new(@server).perform
    redirect_to @server, notice: 'User successfully added to server.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_server
    @server = Server.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def server_params
    params.require(:server).permit(:identifier, :host, :port, :user)
  end
end
