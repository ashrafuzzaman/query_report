require 'query_report/chart/chart_column'
require 'query_report/chart/themes'

module QueryReport
  module Chart
    class ChartBase
      attr_reader :title, :options, :columns, :data

      def initialize(title, query, options={})
        @title = title
        @query = query
        @options = {:width => 500, :height => 240}.merge(options)
      end

      def add(column_title, &block)
        val = block.call(@query)
        @columns ||= []
        @columns << QueryReport::Chart::Column.new(column_title, val.kind_of?(String) ? :string : :number)
        @data ||= []
        @data << val
      end

      def prepare_visualr(type)
        @data_table = GoogleVisualr::DataTable.new

        ##### Adding column header #####
        @data_table.new_column('string', '') if type == :column
        @columns.each do |col|
          @data_table.new_column(col.type.to_s, col.title)
        end
        ##### Adding column header #####

        ##### Adding value #####
        chart_row_data = type == :column ? [''] + @data : @data
        @data_table.add_row(chart_row_data)
        ##### Adding value #####

        options = {:title => title, backgroundColor: 'transparent'}.merge(@options)
        chart_type = "#{type}_chart".classify
        chart_type = "GoogleVisualr::Interactive::#{chart_type}".constantize
        chart_type.new(@data_table, options)
      end

      def to_blob(type)
        chart_type = type.to_s.classify
        chart_type = "Gruff::#{chart_type}".constantize

        @gruff = chart_type.new(@options[:width])
        @gruff.title = title
        @gruff.theme = QueryReport::Chart::Themes::GOOGLE_CHART
        @data.each_with_index do |value, i|
          @gruff.data(@columns[i].title, value)
        end

        @gruff.to_blob
      end
    end
  end
end