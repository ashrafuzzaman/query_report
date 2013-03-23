module QueryReport
  class Filter
    attr_reader :column, :type, :comparators

    def initialize(column, options, &block)
      @column = column
      @type = options if options.kind_of? String
      if options.kind_of? Hash
        @type = options[:type]
        @comparators = options[:comp] || detect_comparators(@type)
      end
    end

    def self.supported_types
      [:date_range, :text]
    end

    supported_types.each do |supported_type|
      define_method("#{supported_type.to_s}?") do
        @type == supported_type
      end
    end

    private
    def detect_comparators(type)
      case type
        when :date_range
          return {gteq: 'From', lteq: 'To'}
        when :text
          return {cont: @column.to_s.humanize}
      end
      {eq: 'Equal'}
    end
  end

end