require 'spec_helper'
require 'query_report/chart/chart_base'

if defined? ActiveRecord
  describe QueryReport::Chart::ChartBase do
    it 'should have title and options' do
      options = {test: 'test'}
      chart = QueryReport::Chart::ChartBase.new("test", Object.new, options)
      expect(chart.title).to eq 'test'
      expect(chart.options).to eq(:width => 500, :height => 240, test: 'test')
    end

    it 'should be able to override options' do
      options = {test: 'test', :width => 550}
      chart = QueryReport::Chart::ChartBase.new("test", Object.new, options)
      expect(chart.options).to eq(:width => 550, :height => 240, test: 'test')
    end

    it 'should add column and detect type' do
      chart = QueryReport::Chart::ChartBase.new("test", Object.new)
      chart.add 'Total charged' do |query|
        100
      end
      chart.add 'Total paid' do |query|
        100
      end

      expect(chart.columns.size).to be 2
      expect(chart.columns[0].title).to eq 'Total charged'
      expect(chart.columns[0].type).to eq :number

      expect(chart.columns[1].title).to eq 'Total paid'
      expect(chart.columns[1].type).to eq :number
    end
  end
end