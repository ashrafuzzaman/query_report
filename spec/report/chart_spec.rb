require 'spec_helper'
require 'query_report/chart/chart_base'

describe QueryReport::Chart::ChartBase do
  it 'should have title and options' do
    options = {test: 'test'}
    chart = QueryReport::Chart::ChartBase.new("test", Object.new, options)
    chart.title.should == 'test'
    chart.options.should == {:width => 500, :height => 240, test: 'test'}
  end

  it 'should be able to override options' do
    options = {test: 'test', :width => 550}
    chart = QueryReport::Chart::ChartBase.new("test", Object.new, options)
    chart.options.should == {:width => 550, :height => 240, test: 'test'}
  end

  it 'should add column and detect type' do
    chart = QueryReport::Chart::ChartBase.new("test", Object.new)
    chart.add 'Total charged' do |query|
      100
    end
    chart.add 'Total paid' do |query|
      100
    end

    chart.columns.size.should be 2
    chart.columns[0].title.should == 'Total charged'
    chart.columns[0].type.should == :number

    chart.columns[1].title.should == 'Total paid'
    chart.columns[1].type.should == :number
  end
end