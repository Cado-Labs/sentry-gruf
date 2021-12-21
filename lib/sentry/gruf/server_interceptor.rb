# frozen_string_literal: true

module Sentry
  module Gruf
    class ServerInterceptor < ::Gruf::Interceptors::ServerInterceptor
      def call
        yield
      rescue Exception => e
        ::Sentry.configure_scope do |scope|
          scope.set_transaction_name(request.service_key)
          scope.set_tags(
            grpc_method: request.method_key,
            grpc_request_class: request.request_class.name,
            grpc_service_key: request.service_key,
          )
        end

        ::Sentry::Gruf.capture_exception(e)

        raise
      end
    end
  end
end
