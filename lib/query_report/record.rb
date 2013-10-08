module QueryReport
  module Record
    attr_accessor :query

    def model_class
      query.klass
    end

    def filtered_query
      apply
      @filtered_query
    end

    def paginated_query
      apply
      @paginated_query
    end

    def search
      apply
      @search
    end

    def apply
      @filtered_query ||= apply_filters(query.clone, @params)
      @paginated_query ||= apply_pagination(@filtered_query, @params)
    end

    def records
      @records ||= map_record(paginated_query, true)
    end

    def all_records
      @all_records ||= map_record(filtered_query, false)
    end

    def map_record(query, render_from_view)
      @columns = @columns.delete_if { |col| col.only_on_web? } unless render_from_view

      query.map do |record|
        array = @columns.collect { |column| [column.humanize, column.value(record)] }
        Hash[*array.flatten]
      end
    end

    def has_any_rowspan?
      @has_any_rowspan = @columns.any?(&:rowspan?) if @has_any_rowspan.nil?
      @has_any_rowspan
    end

    def rowspan_for(column, index)
      length = records.length
      val = records[index][column.humanize]
      rowspan = 0
      index.upto(length-1) do |i|
        if records[i][column.humanize] == val
          rowspan += 1
        else
          break
        end
      end
      rowspan
    end

    def new_row_for_rowspan?(column, index)
      return true if index == 0
      return records[index][column.humanize] != records[index-1][column.humanize]
    end
  end
end