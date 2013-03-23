module QueryReport
  module Chart
    class CustomChart
      attr_reader :title, :type, :options, :data_table, :row

      def initialize(type, title, query, options={})
        @type = type
        @title = title
        @query = query
        @options = options
        @row = []
        @data_table = GoogleVisualr::DataTable.new
      end

      def add_column(title)
        @data_table.new_column('string', title)
        @row << title.humanize
      end

      def add(column_title, &block)
        val = block.call(@query)
        @data_table.new_column(val.kind_of?(String) ? 'string' : 'number', column_title)
        @row << val
      end

      def prepare
        data_table.add_row(@row)
        opts = {:width => 500, :height => 240, :title => @title}.merge(options)
        chart_type = "#{type}_chart".classify
        chart_type = "GoogleVisualr::Interactive::#{chart_type}".constantize
        chart_type.new(data_table, opts)
      end
    end
  end
end