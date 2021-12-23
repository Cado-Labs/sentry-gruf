# frozen_string_literal: true

require "gruf"

require "sentry-ruby"
require "sentry/integrable"

require_relative "gruf/version"

# Namespace, used by the `sentry-ruby-core` gem.
# @see https://rubydoc.info/gems/sentry-ruby-core Sentry documentation
module Sentry
  # gruf-sentry is a library that provides both client-side and server-side interceptors
  # that send uncaught error data to Sentry.
  module Gruf
    extend Integrable
    register_integration name: "gruf", version: Sentry::Gruf::VERSION
  end
end

require_relative "gruf/server_interceptor"
require_relative "gruf/client_interceptor"
