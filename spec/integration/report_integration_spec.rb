require 'spec_helper'
require 'query_report/helper'
require 'fake_app/active_record/models'

class UserController
  attr_accessor :params, :view_context
  include QueryReport::Helper

  def initialize
    @params = {}
    @view_context = Object.new
    #@view_context.define_method(:link_to) do |text, *args|
    #  text
    #end
  end

  def render_report #override the existing renderer
  end
end

describe UserController do
  before(:each) do
    User.scoped.destroy_all
    @user1 = User.create(name: 'User#1', age: 10)
    @user2 = User.create(name: 'User#2', age: 20)
    @user3 = User.create(name: 'User#3', age: 34)
  end

  it "should only show selected columns with readable names" do
    class UserController
      def index_with_readable_names
        @useroices = User.scoped
        reporter(@useroices) do
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

  context 'filter' do
    class UserController
      def index_with_default_filter
        ap params
        @useroices = User.scoped
        reporter(@useroices) do
          filter :age, default: 10
          filter :created_at, type: :date, default: [5.months.ago.to_date.to_s(:db), 1.months.from_now.to_date.to_s(:db)]

          column :name
          column :age
        end
      end
    end

    it "should initialize without any filter applied" do
      controller = UserController.new
      controller.index_with_default_filter
      report = controller.instance_eval { @report }
      report.records.should == [{'Name' => @user1.name, 'Age' => @user1.age}]
    end

    it "should initialize with filter applied" do
      controller = UserController.new
      controller.params[:q] = {age_eq: '34'}
      controller.index_with_default_filter
      report = controller.instance_eval { @report }
      report.records.should == [{'Name' => @user3.name, 'Age' => @user3.age}]
    end
  end
end