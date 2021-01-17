class SshKeysController < ApplicationController
  before_action :get_user

  def new
    @ssh_key = @user.ssh_keys.new
  end

  def create
    @ssh_key = @user.ssh_keys.create(ssh_key_params)
    if @ssh_key.persisted?
      redirect_to @user, notice: 'New SSH key successfuly created'
    else
      render action: :new
    end
  end

  def destroy
    @ssh_key = @user.ssh_keys.find(params[:id])
    @ssh_key.destroy
    redirect_to @user, notice: 'SSH key deleted'
  end

  private

  def get_user
    @user = User.find(params[:user_id])
  end

  def ssh_key_params
    params.require(:ssh_key).permit(:identifier, :key)
  end
end