module QueryReport
  module Chart
    class PieChart
      attr_reader :title, :options, :data_table, :query, :rows

      def initialize(title, query, options={})
        @title = title
        @options = options
        @rows = []
        @query = query
        @data_table = GoogleVisualr::DataTable.new
        @data_table.new_column('string', 'Item')
        @data_table.new_column('number', 'Value')
      end

      def add(column_title, &block)
        val = block.call(@query)
        @rows << [column_title, val]
      end

      def prepare
        @data_table.add_rows(@rows)
        opts = {:width => 500, :height => 240, :title => @title, :is3D => true}.merge(options)
        GoogleVisualr::Interactive::PieChart.new(@data_table, opts)
      end
    end
  end
end