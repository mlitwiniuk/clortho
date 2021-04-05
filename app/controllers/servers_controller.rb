class ServersController < ApplicationController
  before_action :set_server, except: %i[index new create]

  # GET /servers
  def index
    @servers = Server.all
  end

  # GET /servers/1
  def show; end

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
    redirect_to @server, notice: 'Resync scheduled, reload page in a while'
  end

  def remove_user
    @server.users.destroy(User.find(params[:user_id]))
    redirect_to @server, notice: 'User successfully removed from server.'
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
