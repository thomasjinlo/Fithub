require 'rails_helper'



describe UserActivitiesController do

  describe 'with_logged_in_user' do
    let(:user){ create(:user) }
    let(:user_activity){ create(:user_activity, user: user) }

  before :each do
    request.cookies["auth_token"] = user.auth_token
  end

end

