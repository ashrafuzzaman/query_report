require 'ransack/adapters/active_record' if defined?(::ActiveRecord::Base)
require 'spec_helper'
require 'query_report/report'
require 'query_report/report_pdf'
require 'fake_app/active_record/config'
require 'fake_app/active_record/models'

describe 'Integration' do
  before(:each) do
    params = {}
    view_context = ApplicationController.helpers
    options = {}
    @report = QueryReport::Report.new(params, view_context, options)

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

    context 'with sorting applied' do
      context 'with ASC sorting' do
        before { @report.instance_variable_set :@params, {q: {s: 'age ASC'}} }
        its(:records) { should == [{'Name' => @user1.name, 'Age' => @user1.age},
                                   {'Name' => @user2.name, 'Age' => @user2.age}] }
      end
      context 'with DESC sorting' do
        before { @report.instance_variable_set :@params, {q: {s: 'age DESC'}} }
        its(:records) { should == [{'Name' => @user2.name, 'Age' => @user2.age},
                                   {'Name' => @user1.name, 'Age' => @user1.age}] }
      end
    end

    context 'with filter applied' do
      before { subject.params[:q] = {age_eq: '34'} }
      its(:records) { should == [{'Name' => @user3.name, 'Age' => @user3.age}] }
    end
  end
end