module Securenv
  class Client
    attr_reader :app
    attr_reader :stage
    def initialize(app:, stage:)
      @app = app
      @stage = stage
    end

    def set(variable:, value:)
      parameter_name = parameter_name_for(variable)

      resp = sqs_client.put_parameter({
        name: parameter_name,
        description: "Set via securenv",
        value: value,
        type: "SecureString",
        #key_id: "ParameterKeyId",
        overwrite: true,
        tier: "Standard" # accepts Standard, Advanced, Intelligent-Tiering
      })
      parameter = Parameter.new({
       name: parameter_name,
       version: resp.version,
       value: value
      })

      return parameter
    end

    def get(variable:)
      parameter_name = parameter_name_for(variable)
      resp = sqs_client.get_parameter({
        name: parameter_name,
        with_decryption: true
      })
      parameter = Parameter.new({
       name: parameter_name,
       version: resp.parameter.version,
       value: resp.parameter.value
      })

      return parameter
    rescue Aws::SSM::Errors::ParameterNotFound
      raise ParameterNotFoundError.new "#{variable} is not set for app: #{app} and stage: #{stage}"
    end

    def unset(variable:)
      parameter_name = parameter_name_for(variable)
      sqs_client.delete_parameter({
        name: parameter_name
      })
      parameter = Parameter.new({
       name: parameter_name,
       version: nil,
       value: nil
      })

      return parameter
    rescue Aws::SSM::Errors::ParameterNotFound
      raise ParameterNotFoundError.new "#{variable} is not set for app: #{app} and stage: #{stage}"
    end

    def list
      resp = sqs_client.get_parameters_by_path({
        path: parameter_path,
        with_decryption: true
      })
      parameters = resp.parameters.map do |param|
        Parameter.new({
          name: param.name,
          version: param.version,
          value: param.value
        })
      end

      return parameters
    end

    def parameter_path
      "/#{app}/#{stage}"
    end

    def parameter_name_for(variable)
      "#{parameter_path}/#{variable}"
    end

    def sqs_client
      @sqs_client = Aws::SSM::Client.new
    end
  end
end
