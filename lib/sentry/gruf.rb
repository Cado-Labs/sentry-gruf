# frozen_string_literal: true

require "gruf"

require "sentry-ruby"
require "sentry/integrable"

module Sentry
  module Gruf
    extend Integrable
    register_integration name: "gruf", version: Sentry::Gruf::VERSION
  end
end

require_relative "gruf/version"
require_relative "gruf/server_interceptor"
