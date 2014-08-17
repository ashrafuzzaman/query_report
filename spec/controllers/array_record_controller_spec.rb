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
        filter :email, comp: {cont: 'Email'}

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

    describe "GET /index_with_array" do
      context "as JSON" do
        context "with out filter" do
          it "renders" do
            get :index, format: 'json'
            expect(JSON.parse(response.body.to_s)).to eq [{'Name' => @jitu.name, 'Email' => @jitu.email},
                                                          {'Name' => @setu.name, 'Email' => @setu.email},
                                                          {'Name' => @razeen.name, 'Email' => @razeen.email}]
          end
        end

        # context "with name filter" do
        #   it "renders" do
        #     get :index, format: 'json', q: {name_eq: 'Jitu'}
        #     expect(JSON.parse(response.body.to_s)).to eq [{'Name' => @jitu.name, 'Email' => @jitu.email}]
        #   end
        # end
        #
        # context "with email filter" do
        #   it "renders" do
        #     get :index, format: 'json', q: {email_cont: 'jitu'}
        #     expect(JSON.parse(response.body.to_s)).to eq [{'Name' => @jitu.name, 'Email' => @jitu.email}]
        #   end
        # end
      end

      context "as HTML" do
        it "renders with out filter" do
          get :index, format: 'html'
          expect(response.status).to eq(200)
          expect(assigns[:report].records).to eq [{'Name' => @jitu.name, 'Email' => @jitu.email},
                                                  {'Name' => @setu.name, 'Email' => @setu.email},
                                                  {'Name' => @razeen.name, 'Email' => @razeen.email}]
        end
      end

      context "as JS" do
        it "renders with out filter" do
          get :index, format: 'js'
          expect(response.status).to eq(200)
          expect(assigns[:report].records).to eq [{'Name' => @jitu.name, 'Email' => @jitu.email},
                                                  {'Name' => @setu.name, 'Email' => @setu.email},
                                                  {'Name' => @razeen.name, 'Email' => @razeen.email}]
        end
      end
    end

  end
end