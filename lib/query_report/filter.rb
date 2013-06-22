# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

# The purpose of the filter module is to add feature
# to support report tool to add custom and predefined filters

module QueryReport
  module FilterModule
    attr_accessor :filters

    # Creates a filter and adds to the filters
    # Params:
    # +column+:: the column on which the filter is done on
    # +options+:: Options can have the following,
    #             options[:type] => date | text | whatever
    #             options[:comp] => the comparators used for ransack search, [:gteq, :lteq]
    def filter(column, options={}, &block)
      @filters ||= []
      @filters << Filter.new(@params, column, options, &block)
    end

    def apply_filters(query, params)
      @search = query.search(params[:q])
      query = @search.result

      @filters.each do |filter|
        if filter.custom?
          param = params[:custom_search]
          first_val = param[filter.keys.first] rescue nil
          last_val = param[filter.keys.last] rescue nil
          case filter.keys.size
            when 1
              query = filter.block.call(query, first_val) if first_val.present?
              break
            when 2
              query = filter.block.call(query, first_val, last_val) if first_val.present? and last_val.present?
              break
          end
        end
      end
      query
    end

    class Filter
      attr_reader :params, :column, :type, :comparators, :block, :custom

      # Initializes filter with the proper parameters
      # Params:
      # +params+:: The params from the http request
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

      def custom?
        @block ? true : false
      end

      private
      def detect_comparators(type)
        case type
          when :date
            return {gteq: I18n.t('query_report.filters.from'), lteq: I18n.t('query_report.filters.to')}
          when :text
            return {cont: I18n.t("query_report.filters.#{@column.to_s}.contains")}
        end
        {eq: I18n.t("query_report.filters.#{@column.to_s}.equals")}
      end
    end
  end
end