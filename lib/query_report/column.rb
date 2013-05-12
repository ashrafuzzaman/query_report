module QueryReport
  module ColumnModule
    def column(name, options={}, &block)
      options.merge!(model_name: model_name)
      @columns << Column.new(name, options, block)
    end

    def columns
      @columns
    end

    def column_names
      @column_names ||= (@columns||[]).collect(&:humanize)
    end

    class Column
      attr_reader :name, :options, :type, :data

      def initialize(name, options={}, block = nil)
        @name = name
        @options = options
        @type = (options.kind_of?(Hash) ? options[:type] : options) || 'string'
        @data = block || name.to_sym
      end

      def humanize
        options[:as] || I18n.t("activerecord.models.#{options[:model_name]}.#{name}", :default => name.to_s.humanize)
      end
    end

  end
end