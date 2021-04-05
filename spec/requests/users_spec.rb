require 'rails_helper'
RSpec.describe '/users', type: :request do
  include_context 'request authentication helper methods'
  include_context 'request global before and after hooks'

  let(:authenticated_user) { create(:user) }

  before(:each) { login_as(authenticated_user) }

  let(:valid_attributes) { attributes_for(:user) }

  let(:invalid_attributes) { { email: 'notanemail' } }

  describe 'GET /index' do
    it 'renders a successful response' do
      create_list(:user, 10)
      get users_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      user = create(:user)
      get user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_user_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'render a successful response' do
      user = create(:user)
      get edit_user_url(user)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect { post users_url, params: { user: valid_attributes } }.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect { post users_url, params: { user: invalid_attributes } }.to change(User, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post users_url, params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) { { username: 'batman' } }

      it 'updates the requested user' do
        user = create(:user)
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(user.username).to eq('batman')
      end

      it 'redirects to the user' do
        user = create(:user)
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(response).to redirect_to(user_url(user))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        user = create(:user)
        patch user_url(user), params: { user: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      user = create(:user)
      expect { delete user_url(user) }.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      user = create(:user)
      delete user_url(user)
      expect(response).to redirect_to(users_url)
    end
  end
end
