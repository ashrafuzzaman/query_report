require 'query_report/chart/themes'

module QueryReport
  module ColumnChartModule
    def compare_with_column_chart(title, &block)
      chart = QueryReport::Chart::ColumnChart.new(title, self)
      chart.add_column x_axis
      chart.instance_eval &block if block_given?
      @charts << chart
    end

    class ColumnChart < QueryReport::Chart::ChartBase
      def initialize(title, query, options={})
        super(title, query, options)
      end

      def prepare
        super(:column)
      end

      def to_blob
        super(:bar)
      end
    end
  end
end