# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

# The purpose of the filter module is to add feature
# to support report tool to add custom and predefined filters

require 'query_report/filter_module/comparator'

module QueryReport
  module FilterModule
    class Filter
      attr_reader :params, :column, :type, :comparators, :block, :options

      # Initializes filter with the proper parameters
      # @param params [Hash] The params from the http request
      # @param column [Symbol] the name of the filter or the column name for the filter to be applied on
      # @param block The block is passed for a manual query, The first param the block will receive is the query chain, and the rest is the values for that particular filter.
      # @see FilterModule#filter options
      def initialize(params, column, options, &block)
        @params, @column, @options, @comparators, @block = params, column, options, [], block
        @type = options.kind_of?(String) ? options : options[:type]
        generate_comparators
      end

      def self.supported_types
        [:date, :datetime, :text, :boolean]
      end

      supported_types.each do |supported_type|
        define_method("#{supported_type.to_s}?") do
          @type == supported_type
        end
      end

      def custom?
        (@block || @options[:manual]) ? true : false
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
                              when :datetime
                                {gteq: I18n.t('query_report.filters.from'), lteq: I18n.t('query_report.filters.to')}
                              when :text
                                {cont: I18n.t("query_report.filters.#{@column.to_s}.contains")}
                              else
                                {eq: I18n.t("query_report.filters.#{@column.to_s}.equals")}
                            end

        if @options[:comp]
          @options[:comp].each_with_index do |(ransack_search_key, filter_name), i|
            default = nil
            default = @options[:default].kind_of?(Array) ? @options[:default][i] : @options[:default] unless @options[:default].nil?
            @comparators << Comparator.new(self, ransack_search_key, filter_name, default)
          end
        end
      end
    end
  end
end