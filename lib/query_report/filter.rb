module QueryReport
  class Filter
    attr_reader :params, :column, :type, :comparators, :block, :custom

    def initialize(params, column, options, &block)
      @params = params
      @column = column
      @type = options if options.kind_of? String
      if options.kind_of? Hash
        @type = options[:type]
        @comparators = options[:comp] || detect_comparators(@type)
      end
      @block = block
      @custom = @block ? true : false
    end

    def self.supported_types
      [:date, :text]
    end

    def keys
      @keys ||= (@comparators || {}).keys.map { |comp| "#{column.to_s}_#{comp}" }
    end

    supported_types.each do |supported_type|
      define_method("#{supported_type.to_s}?") do
        @type == supported_type
      end
    end

    def filter_with_values
      hash = {}
      @comparators.each do |key, filter_name|
        [key, filter_name]
        param_key = "#{column.to_s}_#{key.to_s}"
        hash[filter_name] = @params['q'][param_key] || @params['custom_search'][param_key] rescue ''
      end
      hash
    end

    private
    def detect_comparators(type)
      case type
        when :date
          return {gteq: I18n.t('query_report.filters.from'), lteq: I18n.t('query_report.filters.to')}
        when :text
          return {cont: @column.to_s.humanize}
      end
      {eq: I18n.t('query_report.filters.equal')}
    end
  end
end