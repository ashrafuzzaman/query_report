require 'ransack/adapters/active_record' if defined?(::ActiveRecord::Base)
require 'spec_helper'
require 'query_report/report'
require 'query_report/report_pdf'
require 'fake_app/active_record/config'
require 'fake_app/active_record/models'

if defined? ActiveRecord
  describe QueryReport::ReportPdf do
    before(:each) do
      @user1 = User.create(name: 'User#1', age: 10, dob: 10.years.ago)
      @user2 = User.create(name: 'User#2', age: 20, dob: 20.years.ago)
      @user3 = User.create(name: 'User#3', age: 34, dob: 34.years.ago)
    end

    let(:params) { {} }
    let(:view_context) { ApplicationController.helpers }
    let(:options) { {} }
    let(:report) { QueryReport::Report.new(params, view_context, options) }

    context 'with selected columns' do
      it "generates PDF report" do
        report.query = User.scoped
        report.instance_eval do
          column :name
          column :age, only_on_web: true
        end

        #should not contain only on web column
        report.all_records.should == [{'Name' => @user1.name},
                                      {'Name' => @user2.name},
                                      {'Name' => @user3.name}]

        pdf = QueryReport::ReportPdf.new(report).to_pdf.render
        pdf.should_not be nil
      end
    end

    context 'with charts' do
      it "generates PDF report" do
        report.query = User.scoped
        report.instance_eval do
          column :name

          column_chart('Age') do
            add 'Average age' do |query|
              query.average(:age)
            end
          end

          #has an issue to render the pie chart in the ruby 2.1.0
          #pie_chart('Age') do
          #  add 'Average age' do |query|
          #    query.average(:age)
          #  end
          #end
        end

        #should not contain only on web column
        report.all_records.should == [{'Name' => @user1.name},
                                      {'Name' => @user2.name},
                                      {'Name' => @user3.name}]

        pdf = QueryReport::ReportPdf.new(report).to_pdf.render
        pdf.should_not be nil
      end
    end

    context 'with custom layout' do
      before do
        class PdfReportTemplateTest < QueryReport::ReportPdf
          def render_header
            pdf.text "Test title", :size => 20, :style => :bold
          end

          def render_footer
            pdf.text "Copyright to @ashraf", :size => 12
          end

          def to_pdf
            render_header
            super
            render_footer
            pdf
          end
        end

        QueryReport.configure do |c|
          c.pdf_options[:template_class] = PdfReportTemplateTest
        end
      end
      it "generates PDF report" do
        report.query = User.scoped
        report.instance_eval do
          column :name
          column :age, only_on_web: true
        end

        #should not contain only on web column
        report.all_records.should == [{'Name' => @user1.name},
                                      {'Name' => @user2.name},
                                      {'Name' => @user3.name}]

        pdf = PdfReportTemplateTest.new(report).to_pdf.render
        pdf.should_not be nil
      end
      after do
        QueryReport.configure do |c|
          c.pdf_options[:template_class] = nil
        end
      end
    end

    context 'with column alignment' do
      before do
        params = {}
        view_context = ApplicationController.helpers
        options = {}
        @report = QueryReport::Report.new(params, view_context, options)

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
end