class WelcomeController < ApplicationController
  def index
    @servers = Server.order(identifier: :asc).all
  end
end
