require 'spec_helper'
require 'query_report/helper'
require 'query_report/report_pdf'
require 'fake/active_record/models'

describe QueryReport::ReportPdf do
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
        column :age, align: :right, show_total: true
      end
    end
    subject { QueryReport::ReportPdf.new(@report).send :table_content_for, @report }

    it { should == [[{:content => "User#1", :align => :left}, {:content => "10", :align => :right}],
                    [{:content => "User#2", :align => :left}, {:content => "20", :align => :right}],
                    [{:content => "User#3", :align => :left}, {:content => "34", :align => :right}],
                    [{:content => "Total"}, {:content => '64.0', :align => :right}]] }
  end
end