require 'rails_helper'

RSpec.describe 'Welcome', type: :request do
  include_context 'request authentication helper methods'
  include_context 'request global before and after hooks'

  let(:authenticated_user) { create(:user) }
  let(:user) { create(:user) }

  describe 'GET /' do
    it 'returns http success' do
      login_as(authenticated_user)
      get '/'
      expect(response).to have_http_status(:success)
    end

    it 'redirects to login' do
      get '/'
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
