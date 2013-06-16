module QueryReport
  module FilterModule
    attr_accessor :filters

    def filter(column, options, &block)
      @filters ||= []
      @filters << Filter.new(@params, column, options, &block)
    end

    class Filter
      attr_reader :params, :column, :type, :comparators, :block, :custom

      def initialize(params, column, options, &block)
        @params = params
        @column = column
        @type = options if options.kind_of? String
      end
    end
  end
end