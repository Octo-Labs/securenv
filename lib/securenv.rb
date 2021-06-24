require "securenv/version"
require "securenv/client"
require "securenv/parameter"

require 'aws-sdk-ssm'

module Securenv
  class ParameterNotFoundError < StandardError; end
end
