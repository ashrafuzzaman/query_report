require 'spec_helper'
require 'query_report/helper'
require 'fake/active_record/models'

describe 'Integration' do
  before(:each) do
    params = {}
    view_context = Object.new
    options = {}
    @report = QueryReport::Report.new(params, view_context, options)

    User.destroy_all
    @user1 = User.create(name: 'User#1', age: 10, dob: 10.years.ago)
    @user2 = User.create(name: 'User#2', age: 20, dob: 20.years.ago)
    @user3 = User.create(name: 'User#3', age: 34)
  end

  context 'with selected columns' do
    before do
      @report.query = User.scoped
      @report.instance_eval do
        column :name
        column :age, only_on_web: true
      end
    end
    subject { @report }

    its(:records) { should == [{'Name' => @user1.name, 'Age' => @user1.age},
                               {'Name' => @user2.name, 'Age' => @user2.age},
                               {'Name' => @user3.name, 'Age' => @user3.age}] }

    its(:all_records) { should == [{'Name' => @user1.name},
                                   {'Name' => @user2.name},
                                   {'Name' => @user3.name}] }
  end

  describe 'filter' do
    before do
      @report.query = User.scoped
      @report.instance_eval do
        filter :age
        filter :dob, type: :datetime, default: [21.years.ago, 1.months.from_now]

        column :name
        column :age
      end
    end
    subject { @report }

    context 'without any filter applied' do
      its(:records) { should == [{'Name' => @user1.name, 'Age' => @user1.age},
                                 {'Name' => @user2.name, 'Age' => @user2.age}] }
    end

    context 'with filter applied' do
      before { subject.params[:q] = {age_eq: '34'} }
      its(:records) { should == [{'Name' => @user3.name, 'Age' => @user3.age}] }
    end
  end
end