# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

module QueryReport
  module FilterModule
    class Comparator
      attr_reader :filter, :type, :name, :default

      def initialize(filter, type, name, default=nil)
        @filter, @type, @name, @default = filter, type, name, default
      end

      def search_key
        "#{@filter.column.to_s}_#{@type}".to_sym
      end

      def search_tag_name
        "#{@filter.params_key}[#{search_key.to_s}]"
      end

      def param_value
        @filter.params[@filter.params_key] ? @filter.params[@filter.params_key][search_key] : stringified_default
      end

      def has_default?
        !@default.nil?
      end

      def stringified_default
        @stringified_default ||= case @filter.type
                                   when :date
                                     @default.kind_of?(String) ? @default : (I18n.l(@default, format: QueryReport.config.date_format) rescue @default)
                                   when :datetime
                                     @default.kind_of?(String) ? @default : (I18n.l(@default, format: QueryReport.config.datetime_format) rescue @default)
                                   else
                                     @default.to_s
                                 end
      end

      #convert param value which is a string to object like date and boolean
      def objectified_param_value
        @objectified_param_value ||= case @filter.type
                                       when :date
                                         format = I18n.t("date.formats.#{QueryReport.config.date_format}")
                                         param_value.kind_of?(String) ? (Date.strptime(param_value, format) rescue param_value) : param_value
                                       when :datetime
                                         param_value.kind_of?(String) ? Time.zone.parse(param_value) : param_value
                                       when :boolean
                                         param_value.to_boolean
                                       else
                                         param_value
                                     end
      end
    end
  end
end