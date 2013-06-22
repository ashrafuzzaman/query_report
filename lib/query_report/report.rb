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