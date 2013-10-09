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

    def records_with_rowspan
      @records_with_rowspan ||= map_rowspan(records)
    end

    def all_records_with_rowspan
      @all_records_with_rowspan ||= map_rowspan(all_records)
    end

    def map_rowspan(rec)
      last_reset_index = @columns.select(&:rowspan?).inject({}) { |hash, column| hash[column.humanize] = 0; hash }
      last_column_content = {}
      rec.each_with_index do |row, index|
        last_reset_index.each do |col, last_index|
          content = row[col]
          last_content = last_column_content[col]
          if index == 0 || content != last_content
            last_column_content[col] = content
            last_reset_index[col]    = index
            #initialize
            row[col] = {content: content, rowspan: 1}
          elsif content == last_content
            rec[last_index][col][:rowspan] += 1
            row.delete col
          end
        end
      end
    end
  end
end