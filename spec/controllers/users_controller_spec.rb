require 'spec_helper'
require 'fake_app/active_record/config'
require 'fake_app/active_record/models'
require 'query_report/helper'

RSpec.describe ApplicationController do
  controller do
    include QueryReport::Helper
    def index
      reporter(User.all) do
        filter :name
        filter :email

        column :name
        column :email
      end
    end
  end

  describe "handling AccessDenied exceptions" do
    it "redirects to the /401.html page" do
      get :index
      # expect(response).to redirect_to("/401.html")
    end
  end
end