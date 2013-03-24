module QueryReport
  module Chart
    class BasicChart
      attr_reader :title, :columns, :type, :data, :options

      def initialize(type, name, columns, data, options={})
        @type = type
        @name = name
        @columns = []
        columns.each_with_index do |column, i|
          @columns << QueryReport::Column.new(column, {type: (i == 0 ? 'string' : 'number')})
        end
        @data = data
        @options = options
      end

      def prepare
        data_table = GoogleVisualr::DataTable.new
        columns.each do |column|
          data_table.new_column(column.type, column.name)
        end

        rows = []
        @data.each do |record|
          row = []
          columns.each do |column|
            row << record[column.name]
          end
          rows << row
        end
        data_table.add_rows(rows)

        opts = {:width => 400, :height => 240, :title => title, :hAxis => {:title => columns[0].name}}.merge(options)

        chart_type = "#{type}_chart".classify
        chart_type = "GoogleVisualr::Interactive::#{chart_type}".constantize
        chart_type.new(data_table, opts)
      end
    end
  end
end