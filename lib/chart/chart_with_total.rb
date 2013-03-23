module QueryReport
  module Chart
    class ChartWithTotal
      attr_reader :title, :columns, :type, :data, :options

      def initialize(type, name, columns, data, options={})
        @type = type
        @name = name
        @columns = []
        columns.each do |column|
          @columns << QueryReport::Column.new(column, 'number')
        end
        @data = data
        @options = options
      end

      def prepare
        data_table = GoogleVisualr::DataTable.new
        columns.each do |column|
          data_table.new_column(column.type, column.name)
        end

        row = []
        columns.each do |column|
          total = 0
          @data.each do |r|
            total += r[column].to_f
          end
          row << total
        end

        data_table.add_row(row)

        opts = {:width => 400, :height => 240, :title => title}.merge(options)

        chart_type = "#{type}_chart".classify
        chart_type = "GoogleVisualr::Interactive::#{chart_type}".constantize
        chart_type.new(data_table, opts)
      end
    end
  end

  #class ColumnChartWithTotal
  #  attr_reader :title, :columns, :type, :data, :options
  #
  #  def initialize(type, name, columns, data, options={})
  #    @type = type
  #    @name = name
  #    @columns = []
  #    columns.each do |column|
  #      @columns << Report::Column.new(column, 'number')
  #    end
  #    @data = data
  #    @options = options
  #  end
  #
  #  def prepare
  #    data_table = GoogleVisualr::DataTable.new
  #    columns.each do |column|
  #      data_table.new_column(column.type, column.name)
  #    end
  #
  #    row = []
  #    columns.each do |column|
  #      total = 0
  #      @data.each do |r|
  #        total += r[column].to_f
  #      end
  #      row << total
  #    end
  #
  #    data_table.add_row(row)
  #
  #    opts = {:width => 400, :height => 240, :title => title}.merge(options)
  #
  #    chart_type = "#{type}_chart".classify
  #    chart_type = "GoogleVisualr::Interactive::#{chart_type}".constantize
  #    chart_type.new(data_table, opts)
  #  end
  #end

end