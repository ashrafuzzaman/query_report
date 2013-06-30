module QueryReport
  module Chart
    class Column
      attr_reader :title, :type

      def initialize(title, type)
        @title = title
        @type = type
      end
    end
  end
end