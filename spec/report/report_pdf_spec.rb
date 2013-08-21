require 'spec_helper'
require 'query_report/report'
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
    @user3 = User.create(name: 'User#3', age: 34, dob: 34.years.ago)
  end

  context 'with selected columns' do
    it "generates PDF report" do
      QueryReport.configure do |c|
        c.pdf_options[:template_class] = 'Test'
      end

      @report.query = User.scoped
      @report.instance_eval do
        column :name
        column :age, only_on_web: true
      end

      #should not contain only on web column
      @report.all_records.should == [{'Name' => @user1.name},
                                     {'Name' => @user2.name},
                                     {'Name' => @user3.name}]

      pdf = QueryReport::ReportPdf.new(@report).standard
    end
  end

end