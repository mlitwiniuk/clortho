 require 'rails_helper'

RSpec.describe "/servers", type: :request do
  let(:valid_attributes) {
    attributes_for(:server)
  }

  let(:invalid_attributes) {
    { port: "foo" }
  }

  describe "GET /index" do
    it "renders a successful response" do
      create(:server)
      get servers_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      server = create(:server)
      get server_url(server)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_server_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      server = create(:server)
      get edit_server_url(server)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Server" do
        expect {
          post servers_url, params: { server: valid_attributes }
        }.to change(Server, :count).by(1)
      end

      it "redirects to the created server" do
        post servers_url, params: { server: valid_attributes }
        expect(response).to redirect_to(server_url(Server.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Server" do
        expect {
          post servers_url, params: { server: invalid_attributes }
        }.to change(Server, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post servers_url, params: { server: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { host: 'google.com', port: 2222, identifier: 'google', user: 'brian'}
      }

      it "updates the requested server" do
        server = create(:server)
        patch server_url(server), params: { server: new_attributes }
        server.reload
        expect(server.host).to eq(new_attributes[:host])
        expect(server.port).to eq(new_attributes[:port])
        expect(server.identifier).to eq(new_attributes[:identifier])
        expect(server.user).to eq(new_attributes[:user])
      end

      it "redirects to the server" do
        server = create(:server)
        patch server_url(server), params: { server: new_attributes }
        server.reload
        expect(response).to redirect_to(server_url(server))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        server = create(:server)
        patch server_url(server), params: { server: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested server" do
      server = create(:server)
      expect {
        delete server_url(server)
      }.to change(Server, :count).by(-1)
    end

    it "redirects to the servers list" do
      server = create(:server)
      delete server_url(server)
      expect(response).to redirect_to(servers_url)
    end
  end
end
