require 'spec_helper'
require 'query_report/helper'
require 'fake/active_record/models'

class UserController
  attr_accessor :params, :view_context
  include QueryReport::Helper

  def initialize
    @params = {}
    @view_context = Object.new
  end

  def render_report #override the existing renderer
  end
end

describe 'Integration' do
  before(:each) do
    User.destroy_all
    @user1 = User.create(name: 'User#1', age: 10, dob: 10.years.ago)
    @user2 = User.create(name: 'User#2', age: 20, dob: 20.years.ago)
    @user3 = User.create(name: 'User#3', age: 34, dob: 34.years.ago)
  end

  context 'with selected columns' do
    it "shows with readable names" do
      class UserController
        def index_with_readable_names
          @users = User.scoped
          reporter(@users) do
            column :name
            column :age
          end
        end
      end

      controller = UserController.new
      controller.index_with_readable_names
      report = controller.instance_eval { @report }
      report.records.should == [{'Name' => @user1.name, 'Age' => @user1.age},
                                {'Name' => @user2.name, 'Age' => @user2.age},
                                {'Name' => @user3.name, 'Age' => @user3.age}]
    end
  end


  describe 'filter' do
    class UserController
      def index_with_default_filter
        @users = User.scoped
        reporter(@users) do
          filter :age, default: 10
          filter :created_at, type: :date, default: [5.months.ago.to_date.to_s(:db), 1.months.from_now.to_date.to_s(:db)]

          column :name
          column :age
        end
      end
    end

    context 'without any filter applied' do
      let(:controller) { UserController.new }

      it "initializes" do
        controller.index_with_default_filter
        report = controller.instance_eval { @report }
        report.records.should == [{'Name' => @user1.name, 'Age' => @user1.age}]
      end
    end

    context 'with filter applied' do
      let(:controller) { UserController.new }

      it "initializes" do
        controller.params[:q] = {age_eq: '34'}
        controller.index_with_default_filter
        report = controller.instance_eval { @report }
        report.records.should == [{'Name' => @user3.name, 'Age' => @user3.age}]
      end
    end
  end
end