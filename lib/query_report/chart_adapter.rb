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

      ap chart_adapter.chart.data
      ap chart_adapter.chart
    end

    class ChartAdapter
      attr_accessor :query, :chart_type, :chart
      delegate :data, :data=, :columns, :columns=, :label_column, :label_column=, to: :chart

      def initialize(query, chart_type, chart_title)
        @query = query
        @chart_type = chart_type
        @chart = "Chartify::#{chart_type.to_s.camelize}Chart".constantize.new
        @chart.title = chart_title
        # do |chart|
        #   chart.data = [{hours_remain: 100, estimated_hours_remain: 100, day: 3.days.ago.to_date},
        #                 {hours_remain: 50, estimated_hours_remain: 45, day: 2.days.ago.to_date},
        #                 {hours_remain: 5, estimated_hours_remain: 10, day: 1.days.ago.to_date}]
        #   chart.columns = {hours_remain: 'Hours remaining', estimated_hours_remain: 'Estimated hours remaining'}
        #   chart.label_column = :day
        # end
      end

    end
  end
end