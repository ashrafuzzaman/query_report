require 'spec_helper'
require 'fake_app/active_record/config'
require 'fake_app/active_record/models'
require 'query_report/helper'

RSpec.describe ApplicationController do
  controller do
    include QueryReport::Helper

    def index
      reporter(User.all.to_a) do
        filter :name
        filter :email

        column :name, as: 'Name'
        column :email, as: 'Email'
      end
    end

    def index_with_array
      reporter(User.all.to_a) do
        filter :name
        filter :email

        column :name, as: 'Name'
        column :email, as: 'Email'
      end
    end
  end

  describe QueryReport::Helper do
    before(:each) do
      @jitu = User.create(name: 'Jitu', email: 'jitu@query.com')
      @setu = User.create(name: 'Setu', email: 'setu@query.com')
      @razeen = User.create(name: 'Razeen', email: 'razeen@gmail.com')
    end

    # context "/index" do
    #   it "renders with out filter" do
    #     get :index, format: 'json'
    #     expect(JSON.parse(response.body.to_s)).to eq [{'Name' => @jitu.name, 'Email' => @jitu.email},
    #                                                   {'Name' => @setu.name, 'Email' => @setu.email},
    #                                                   {'Name' => @razeen.name, 'Email' => @razeen.email}]
    #   end
    # end

    context "/index_with_array" do
      it "renders with out filter as json" do
        get :index, format: 'json'
        expect(JSON.parse(response.body.to_s)).to eq [{'Name' => @jitu.name, 'Email' => @jitu.email},
                                                      {'Name' => @setu.name, 'Email' => @setu.email},
                                                      {'Name' => @razeen.name, 'Email' => @razeen.email}]
      end

      it "renders with out filter as html" do
        get :index, format: 'html'
        expect(response.status).to eq(200)
        expect(assigns[:report].records).to eq [{'Name' => @jitu.name, 'Email' => @jitu.email},
                                                {'Name' => @setu.name, 'Email' => @setu.email},
                                                {'Name' => @razeen.name, 'Email' => @razeen.email}]
      end

      it "renders with out filter as js" do
        get :index, format: 'js'
        expect(response.status).to eq(200)
        expect(assigns[:report].records).to eq [{'Name' => @jitu.name, 'Email' => @jitu.email},
                                                {'Name' => @setu.name, 'Email' => @setu.email},
                                                {'Name' => @razeen.name, 'Email' => @razeen.email}]
      end
    end

  end
end