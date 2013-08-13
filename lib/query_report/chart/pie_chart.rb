require 'query_report/chart/themes'
require 'query_report/chart/chart_base'

module QueryReport
  module PieChartModule
    def pie_chart(title, &block)
      chart = QueryReport::Chart::PieChart.new(title, self.filtered_query)
      chart.instance_eval &block if block_given?
      @charts ||= []
      @charts << chart
    end
  end

  module Chart
    class PieChart < QueryReport::Chart::ChartBase
      def initialize(title, query, options={})
        super(title, query, options)
      end

      def prepare_visualr
        @data_table = GoogleVisualr::DataTable.new

        ##### Adding column header #####
        @data_table.new_column('string', 'Item')
        @data_table.new_column('number', 'Value')
        ##### Adding column header #####

        @columns.each_with_index do |column, i|
          @data_table.add_row([column.title, @data[i]])
        end

        options = {:title => title, backgroundColor: 'transparent'}.merge(@options)
        GoogleVisualr::Interactive::PieChart.new(@data_table, options)
      end

      def to_blob
        super(:pie)
      end
    end
  end
end