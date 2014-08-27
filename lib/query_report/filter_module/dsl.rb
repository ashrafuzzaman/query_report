# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

# The purpose of the filter module is to add feature
# to support report tool to add custom and predefined filters

require 'query_report/filter_module/comparator'
require 'query_report/filter_module/filter'

module QueryReport
  module FilterModule
    module DSL
      attr_accessor :filters, :search

      # Creates a filter
      # @param column the column on which the filter is done on, for manual filter the column name can be anything
      # @option options [Symbol] :type date | text | whatever
      # @option options [Array] :comp the comparators used for ransack search, [:gteq, :lteq]
      # @option options [Boolean] :manual if set to true then that filter will not be applied, only will appear and can be used for custom application
      # @option options :default support default filter value, can be one value or for range filter can be array
      #
      # @example Custom type
      #  filter :invoiced_to_id, type: :user
      #
      #  # In a helper file define method
      #  def query_report_user_filter(name, user_id, options={})
      #    user = User.find(user_id)
      #    concat hidden_field_tag name, user_id, options
      #    text_field_tag "#{name}", user.name, class: 'user_search' #implement the filter, it can be autocomplete
      #  end
      #

      def filter(column, options={}, &block)
        @filters ||= []
        @filters << Filter.new(@params, column, options, &block)
      end

      def apply_filters(query, http_params)
        # apply default filter
        params = load_default_values_in_param(http_params) #need for ransack filter
        @search = query.ransack(params[:q])
        query = @search.result

        #this is to fix a bug from ransack, as for ransack when the sorting is done from a joined table it does not sort by default
        query = query.order(params[:q][:s]) if params[:q][:s]

        #apply custom filter
        @filters.select(&:custom?).each do |filter|
          ordered_custom_param_values = ordered_param_value_objects(filter)
          has_no_user_input = ordered_custom_param_values.all? { |p| p.nil? or p == '' }
          query = filter.block.call(query, *ordered_custom_param_values) if filter.block and !has_no_user_input
        end
        query
      end

      def has_filter?
        filters.present?
      end

      def ordered_param_value_objects(filter)
        filter.comparators.collect do |comp|
          comp.objectified_param_value
        end
      end

      def load_default_values_in_param(http_params)
        params = http_params.clone
        params = params.merge(q: {}) unless params[:q]
        params = params.merge(custom_search: {}) unless params[:custom_search]
        @filters.each do |filter|
          filter.comparators.each do |comparator|
            params[filter.params_key][comparator.search_key] ||= comparator.param_value
          end
        end
        params
      end
    end
  end
end