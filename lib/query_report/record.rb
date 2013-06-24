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

    def apply
      @filtered_query ||= apply_filters(query.clone, @params)
      @paginated_query ||= apply_pagination(@filtered_query, @params)
    end

    def records
      @records ||= map_record(paginated_query)
    end

    def all_records
      @all_records ||= map_record(filtered_query)
    end

    def map_record(query)
      query.map do |record|
        array = @columns.collect { |column| [column.name, column.value(record)] }
        Hash[*array.flatten]
      end
    end
  end
end