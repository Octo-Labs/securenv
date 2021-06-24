module Securenv
  class Set
    def call(variable:, value:, app:, stage:)
      key = "#{app}-#{stage}-#{variable}"
      puts "Setting value for key: #{key}"


      resp = client.put_parameter({
        name: key,
        description: "Set via securenv",
        value: value,
        type: "SecureString",
        #key_id: "ParameterKeyId",
        overwrite: true,
        tier: "Standard" # accepts Standard, Advanced, Intelligent-Tiering
      })
    end

    def client
      @client = Aws::SSM::Client.new
    end
  end
end
