require 'query_report/chart/themes'
require 'query_report/chart/chart_base'

module QueryReport
  module ColumnChartModule
    def compare_with_column_chart(title, &block)
      chart = QueryReport::Chart::ColumnChart.new(title, self.filtered_query)
      chart.instance_eval &block if block_given?
      @charts ||= []
      @charts << chart
    end
  end

  module Chart
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