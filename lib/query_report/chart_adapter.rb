# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

# The purpose of the filter module is adapt the chart features form chartify
require 'chartify/factory'

module QueryReport
  module ChartAdapterModule
    def chart(chart_type, chart_title, &block)
      chart_adapter = ChartAdapter.new(filtered_query, chart_type, chart_title)
      block.call(chart_adapter)
      @charts << chart_adapter.chart
    end

    class ChartAdapter
      attr_accessor :query, :chart_type, :chart
      delegate :data, :data=, :columns, :columns=, :label_column, :label_column=, to: :chart

      def initialize(query, chart_type, chart_title)
        @query = query
        @chart_type = chart_type
        @chart = "Chartify::#{chart_type.to_s.camelize}Chart".constantize.new
        @chart.title = chart_title
      end

      def sum_with(options)
        @chart.data = []
        options.each do |column_title, column|
          @chart.data << [column_title, query.sum(column)]
        end
      end
    end
  end
end