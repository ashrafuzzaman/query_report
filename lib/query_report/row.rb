module QueryReport
  class Row
    attr_reader :name, :value, :type

    def initialize(name, value)
      @name  = name
      @value = value
      @type  = value.kind_of?(String) ? 'string' : 'number'
    end
  end
end