require 'query_report/chart/themes'

module QueryReport
  module Chart
    class PieChart
      attr_reader :title, :options, :data_table, :query, :rows

      def initialize(title, query, options={})
        @title = title
        @options = options
        @rows = []
        @query = query
      end

      def add(column_title, &block)
        val = block.call(@query)
        @rows << [column_title, val]
      end

      def prepare
        @data_table = GoogleVisualr::DataTable.new
        @data_table.new_column('string', 'Item')
        @data_table.new_column('number', 'Value')
        @data_table.add_rows(@rows)
        opts = {:width => 500, :height => 240, :title => @title, :is3D => true, backgroundColor: 'transparent'}.merge(options)
        GoogleVisualr::Interactive::PieChart.new(@data_table, opts)
      end

      def prepare_gruff
        @gruff = Gruff::Pie.new(options[:width] || 600)
        @gruff.title = title
        @gruff.theme = Gruff::Themes::GOOGLE_CHART
        @rows.each do |row|
          @gruff.data(row[0], row[1])
        end
      end

      def to_blob
        prepare_gruff
        @gruff.to_blob
      end
    end
  end
end