module Securenv
  class Parameter
    attr_reader :name
    attr_reader :value
    attr_reader :version

    def initialize(name:, value:, version:)
      @name = name
      @value = value
      @version = version
    end

    def var_name
      name.split('/').last
    end
  end
end
