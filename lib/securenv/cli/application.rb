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
        Securenv::Set.new.call({
          variable: variable,
          value: value,
          app: options[:app],
          stage: options[:stage]
        })
      end
    end
  end
end
