module QueryReport
  autoload :ColumnModule, 'query_report/column'
  autoload :FilterModule, 'query_report/filter'
  autoload :PaginateModule, 'query_report/paginate'
  autoload :Record, 'query_report/record'
  autoload :ColumnChartModule, 'query_report/chart/column_chart'
  autoload :PieChartModule, 'query_report/chart/pie_chart'

  DEFAULT_OPTIONS = {enable_chart: true, chart_on_web: true, chart_on_pdf: true, paginate: true}

  class Report
    include QueryReport::ColumnModule
    include QueryReport::FilterModule
    include QueryReport::PaginateModule
    include QueryReport::Record
    include QueryReport::ColumnChartModule
    include QueryReport::PieChartModule

    attr_reader :params, :template, :options, :charts

    def initialize(params, template, options={}, &block)
      @params, @template = params, template
      @columns, @filters, @charts = [], [], []
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

    def has_chart?
      !@charts.empty?
    end

    def has_total?
      @columns.any?(&:has_total?)
    end

    # to support the helper methods
    def method_missing(meth, *args, &block)
      if @template.respond_to?(meth)
        @template.send(meth, *args)
      else
        super
      end
    end
  end
end