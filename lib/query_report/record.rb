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
        array = @columns.collect { |column| [column.humanize, render_from_view ? column.value(record) : strip_tags(column.value(record))] }
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

    def map_rowspan(recs)
      last_reset_index = @columns.select(&:rowspan?).inject({}) { |hash, column| hash[column.humanize] = 0; hash }
      rowspan_column_hash = @columns.select(&:rowspan?).inject({}) { |hash, column| hash[column.humanize] = column.rowspan_column_humanized; hash }

      prev_row = {}
      recs.each_with_index do |row, index|
        last_reset_index.each do |col, last_index|
          rowspan_col = rowspan_column_hash[col]

          rowspan_content = content_from_element(row[rowspan_col]) #picking the current content of the rowspan column
          prev_rowspan_content = content_from_element(prev_row[rowspan_col]) #picking the last rowspan content stored

          content = row[col]
          prev_content = content_from_element(prev_row[col])

          if index == 0 || rowspan_content != prev_rowspan_content || content != prev_content
            last_reset_index[col] = index
            #initialize
            row[col] = {content: content, rowspan: 1}
          elsif rowspan_content == prev_rowspan_content
            recs[last_index][col][:rowspan] += 1
          end
        end

        prev_row = row
      end

      #cleaning up the un needed row values
      recs.each do |row|
        last_reset_index.each do |col, last_index|
          row.delete col unless row[col].kind_of?(Hash)
        end
      end
    end

    def content_from_element(content)
      content.kind_of?(Hash) ? content[:content] : content
    end
  end
end