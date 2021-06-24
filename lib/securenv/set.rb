module Securenv
  class Set
    def call(variable:, value:, app:, stage:)
      key = "#{app}-#{stage}-#{variable}"
      puts "Setting value for key: #{key}"
    end
  end
end
