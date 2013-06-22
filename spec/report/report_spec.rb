require 'spec_helper'
require 'query_report/report'

describe QueryReport::FilterModule do
  it 'initialize' do
    params = {}
    template = Object.new
    report = QueryReport::Report.new(params, template)
    report.params.should be(params)
    report.template.should be(template)
    report.options.should == {chart_on_pdf: true, paginate: true}
  end

  it 'should not eval when block not given' do
    QueryReport::Report.any_instance.should_not_receive(:instance_eval).and_return(nil)
    QueryReport::Report.new({}, Object.new)
  end

  it 'should eval when block given' do
    QueryReport::Report.any_instance.should_receive(:instance_eval).and_return(nil)
    QueryReport::Report.new({}, Object.new) do
    end
  end

  describe 'should provide methods from default options' do
    it 'with out options' do
      report = QueryReport::Report.new({}, Object.new)
      report.chart_on_pdf?.should == true
      report.paginate?.should == true
    end

    it 'with options' do
      report = QueryReport::Report.new({}, Object.new, {chart_on_pdf: false, paginate: true})
      report.chart_on_pdf?.should == false
      report.paginate?.should == true
    end
  end
end