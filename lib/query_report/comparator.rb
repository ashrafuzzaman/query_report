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
        @stringified_default ||= case @filter.type
                                   when :date
                                     @default.kind_of?(String) ? Date.current.parse(@default) : @default
                                   when :datetime
                                     @default.kind_of?(String) ? Time.zone.parse(@default) : @default
                                   when :boolean
                                     @default.to_boolean
                                   else
                                     @default
                                 end
      end
    end
  end
end