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

      it("returns params") { expect(report.params).to be params }
      it("returns template") { expect(report.template).to be template }
      it("returns options") { expect(report.options).to eq(enable_chart: true, chart_on_web: true, chart_on_pdf: true, paginate: true) }
    end

    context 'when block not given' do
      it 'does not eval' do
        expect_any_instance_of(QueryReport::Report).not_to receive(:instance_eval)
        QueryReport::Report.new({}, Object.new)
      end
    end

    context 'when block given' do
      it 'does eval block' do
        expect_any_instance_of(QueryReport::Report).to receive(:instance_eval).and_return(nil)
        QueryReport::Report.new({}, Object.new) do
        end
      end
    end

    describe 'methods from default options' do
      context 'with out options' do
        let(:report) { QueryReport::Report.new({}, Object.new) }
        subject { report }
        it("returns chart_on_pdf?") { expect(report.chart_on_pdf?).to eq true }
        it("returns paginate?") { expect(report.paginate?).to eq true }
      end

      context 'with options' do
        let(:report) { QueryReport::Report.new({}, Object.new, {chart_on_pdf: false, paginate: true}) }
        subject { report }
        it("returns chart_on_pdf?") { expect(report.chart_on_pdf?).to eq false }
        it("returns paginate?") { expect(report.paginate?).to eq true }
      end
    end
  end
end