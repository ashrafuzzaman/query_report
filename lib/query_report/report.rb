require 'query_report/column'
require 'query_report/filter'
require 'query_report/paginate'

module QueryReport
  DEFAULT_OPTIONS = {chart_on_pdf: true, paginate: true}

  class Report
    include QueryReport::ColumnModule
    include QueryReport::FilterModule
    include QueryReport::PaginateModule

    attr_reader :params, :template, :options
    attr_accessor :query

    def initialize(params, template, options={}, &block)
      @params, @template = params, template
      @columns, @filters = [], []
      @options = QueryReport::DEFAULT_OPTIONS.merge options
      instance_eval &block if block_given?
    end

    def model_class
      query.klass
    end

    # define options methods
    QueryReport::DEFAULT_OPTIONS.each do |option_name, value|
      if value.class == TrueClass or value.class == FalseClass
        define_method "#{option_name.to_s}?" do
          @options[option_name]
        end
      end
    end

    def filtered_query
      apply
      @filtered_query
    end

    def apply
      q = query.clone
      q = apply_filters(q, @params)
      @filtered_query = apply_pagination(q, @params)
    end

    def records
      @records ||= map_record(filtered_query)
    end

    def map_record(query)
      query.map do |record|
        array = @columns.collect { |column| [column.name, column.value(record)] }
        Hash[*array.flatten]
      end
    end
  end
end