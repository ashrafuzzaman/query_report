require 'spec_helper'
require 'fake_app/active_record/config'
require 'fake_app/active_record/models'
require 'query_report/report'

if defined? ActiveRecord
  describe QueryReport::Report do
    describe '#initialize' do
      let(:params) { {} }
      let(:template) { Object.new }
      let(:report) { QueryReport::Report.new(params, template) }
      subject { report }

      its(:params) { should be params }
      its(:template) { should be template }
      its(:options) { should == {enable_chart: true, chart_on_web: true, chart_on_pdf: true, paginate: true} }
    end

    context 'when block not given' do
      it 'does not eval' do
        QueryReport::Report.any_instance.should_not_receive(:instance_eval).and_return(nil)
        QueryReport::Report.new({}, Object.new)
      end
    end

    context 'when block given' do
      it 'does eval block' do
        QueryReport::Report.any_instance.should_receive(:instance_eval).and_return(nil)
        QueryReport::Report.new({}, Object.new) do
        end
      end
    end

    describe 'methods from default options' do
      context 'with out options' do
        let(:report) { QueryReport::Report.new({}, Object.new) }
        subject { report }
        its(:chart_on_pdf?) { should == true }
        its(:paginate?) { should == true }
      end

      context 'with options' do
        let(:report) { QueryReport::Report.new({}, Object.new, {chart_on_pdf: false, paginate: true}) }
        subject { report }
        its(:chart_on_pdf?) { should == false }
        its(:paginate?) { should == true }
      end
    end
  end
end