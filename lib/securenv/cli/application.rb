require "thor"
require "securenv"

module Securenv
  module CLI
    class Application < Thor
      # This makes thor report the correct exit code in the event of a failure.
      def self.exit_on_failure?
        true
      end

      desc "set VAR=value", "set a secure environment variable"
      option :app, :required => true, :aliases => "-a", :desc => "The name of the app."
      option :stage, :required => true, :aliases => "-s", :desc => "The name of the stage."
      def set(var)
        variable, value = var.split('=')
        if value.nil?
          raise Thor::Error.new "You must supply a value for #{variable}. To unset a value you can use : securenv unset #{variable}"
        end
        client = Securenv::Client.new({
          app: options[:app],
          stage: options[:stage]
        })
        parameter = client.set({
          variable: variable,
          value: value,
        })

        puts "Set value for parameter name #{parameter.name} for version #{parameter.version}"
      end

      desc "get VAR", "get the current value of a secure environment variable"
      option :app, :required => true, :aliases => "-a", :desc => "The name of the app."
      option :stage, :required => true, :aliases => "-s", :desc => "The name of the stage."
      def get(var)
        client = Securenv::Client.new({
          app: options[:app],
          stage: options[:stage]
        })
        parameter = client.get({
          variable: var
        })

        puts "#{parameter.name} = #{parameter.value}"
      rescue Securenv::ParameterNotFoundError => e
        puts e.to_s
      end

      desc "unset VAR", "remove a secure environment variable"
      option :app, :required => true, :aliases => "-a", :desc => "The name of the app."
      option :stage, :required => true, :aliases => "-s", :desc => "The name of the stage."
      def unset(var)
        client = Securenv::Client.new({
          app: options[:app],
          stage: options[:stage]
        })
        parameter = client.unset({
          variable: var
        })

        puts "#{parameter.name} was removed"
      rescue Securenv::ParameterNotFoundError => e
        puts e.to_s
      end
    end
  end
end
