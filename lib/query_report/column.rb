module QueryReport
  class Column
    attr_reader :name, :options, :type, :data

    def initialize(name, options={}, block = nil)
      @name = name
      @options = options
      @type = (options.kind_of?(Hash) ? options[:type] : options) || 'string'
      @data = block || name.to_sym
    end

    def humanize
      options[:as] || name.to_s.humanize
    end
  end

end