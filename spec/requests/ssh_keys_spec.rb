require 'rails_helper'

RSpec.describe '/users/:user_id/ssh_keys', type: :request do
  include_context 'request authentication helper methods'
  include_context 'request global before and after hooks'

  let(:authenticated_user) { create(:user) }
  let(:user) { create(:user) }

  before(:each) { login_as(authenticated_user) }

  let(:valid_attributes) { attributes_for(:ssh_key) }

  let(:invalid_attributes) { { key: '' } }

  describe 'GET /users/:user_id/new' do
    it 'renders a successful response' do
      get new_user_ssh_key_path(user)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new SSH Key' do
        expect { post user_ssh_keys_path(user), params: { ssh_key: valid_attributes } }.to change(SshKey, :count).by(1)
      end

      it 'redirects to the user' do
        post user_ssh_keys_path(user), params: { ssh_key: valid_attributes }
        expect(response).to redirect_to(user_url(user))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect { post user_ssh_keys_path(user), params: { ssh_key: invalid_attributes } }.to change(SshKey, :count).by(
          0,
        )
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post user_ssh_keys_path(user), params: { ssh_key: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested ssh_key' do
      ssh_key = create(:ssh_key, user: user)
      expect { delete user_ssh_key_path(user, ssh_key) }.to change(SshKey, :count).by(-1)
    end

    it 'redirects to the user overview' do
      ssh_key = create(:ssh_key, user: user)
      delete user_ssh_key_path(user, ssh_key), params: {}, headers: { 'HTTP_REFERER' => "/users/#{user.id}" }
      expect(response).to redirect_to(user_path(user))
    end
  end
end
