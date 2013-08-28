# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

# The purpose of the filter module is to add feature
# to support report tool to add custom and predefined filters

module QueryReport
  module FilterModule
    attr_accessor :filters, :search

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

    def apply_filters(query, http_params)
      # apply default filter
      params = load_default_values_in_param(http_params) #need for ransack filter

      @search = query.search(params[:q])
      query = @search.result

      @filters.each do |filter|
        if filter.custom?
          ordered_custom_param_values = filter.search_keys.collect do |key|
            if filter.boolean?
              params[:custom_search][key].present? ? params[:custom_search][key] == 'true' : nil
            else
              params[:custom_search][key]
            end
          end
          #filter only if there is a given input
          query = filter.block.call(query, *ordered_custom_param_values) unless ordered_custom_param_values.all? { |p| p.nil? or p == '' }
        end
      end
      query
    end

    def load_default_values_in_param(http_params)
      params = http_params.clone
      params = params.merge(q: {}) unless params[:q]
      params = params.merge(custom_search: {}) unless params[:custom_search]
      @filters.each do |filter|
        if filter.has_default?
          filter.comparators.each do |comparator|
            params[filter.params_key][comparator.search_key] ||= comparator.default.to_s
          end
        end
      end
      params
    end

    class Comparator
      attr_reader :filter, :type, :name, :default

      def initialize(filter, type, name, default=nil)
        @filter, @type, @name, @default = filter, type, name, default.to_s
      end

      def search_key
        "#{@filter.column.to_s}_#{@type}".to_sym
      end

      def search_tag_name
        "#{@filter.params_key}[#{search_key.to_s}]"
      end

      def param_value
        @filter.params[@filter.params_key] ? @filter.params[@filter.params_key][search_key] : default
      end

      def has_default?
        !@default.nil?
      end
    end

    class Filter
      attr_reader :params, :column, :type, :comparators, :block, :options

      # Initializes filter with the proper parameters
      # Params:
      # +params+:: The params from the http request
      def initialize(params, column, options, &block)
        @params, @column, @options, @comparators, @block = params, column, options, [], block
        @type = options if options.kind_of? String
        if options.kind_of? Hash
          @type = options[:type]
        end
        generate_comparators
      end

      def self.supported_types
        [:date, :text, :boolean]
      end

      supported_types.each do |supported_type|
        define_method("#{supported_type.to_s}?") do
          @type == supported_type
        end
      end

      def custom?
        @block ? true : false
      end

      def search_keys
        @comparators.collect(&:search_key)
      end

      def has_default?
        @comparators.any?(&:has_default?)
      end

      def params_key
        custom? ? :custom_search : :q
      end

      private
      def generate_comparators
        @options[:comp] ||= case @type
                              when :date
                                {gteq: I18n.t('query_report.filters.from'), lteq: I18n.t('query_report.filters.to')}
                              when :text
                                {cont: I18n.t("query_report.filters.#{@column.to_s}.contains")}
                              else
                                {eq: I18n.t("query_report.filters.#{@column.to_s}.equals")}
                            end

        if @options[:comp]
          @options[:comp].each_with_index do |(search_key, filter_name), i|
            default = nil
            default = @options[:default].kind_of?(Array) ? @options[:default][i] : @options[:default] if @options[:default]
            @comparators << Comparator.new(self, search_key, filter_name, default)
          end
        end
      end
    end
  end
end