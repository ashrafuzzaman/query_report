module QueryReport
  autoload :ColumnModule, 'query_report/column'
  autoload :FilterModule, 'query_report/filter'
  autoload :PaginateModule, 'query_report/paginate'
  autoload :Record, 'query_report/record'
  autoload :ColumnChartModule, 'query_report/chart/column_chart'

  DEFAULT_OPTIONS = {chart_on_pdf: true, paginate: true}

  class Report
    include QueryReport::ColumnModule
    include QueryReport::FilterModule
    include QueryReport::PaginateModule
    include QueryReport::Record
    include QueryReport::ColumnChartModule

    attr_reader :params, :template, :options, :charts

    def initialize(params, template, options={}, &block)
      @params, @template = params, template
      @columns, @filters = [], []
      @options = QueryReport::DEFAULT_OPTIONS.merge options
      instance_eval &block if block_given?
    end

    # define options methods
    QueryReport::DEFAULT_OPTIONS.each do |option_name, value|
      if value.class == TrueClass or value.class == FalseClass
        define_method "#{option_name.to_s}?" do
          @options[option_name]
        end
      end
    end
  end
end