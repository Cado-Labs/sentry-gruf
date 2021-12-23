# frozen_string_literal: true

module Sentry
  module Gruf
    class ClientInterceptor < ::Gruf::Interceptors::ClientInterceptor
      def call(request_context:)
        ::Sentry.configure_scope do |scope|
          scope.set_tags(
            grpc_method_name: request_context.method_name,
            grpc_route_key: request_context.route_key,
            grpc_call_type: request_context.type,
          )
        end

        yield
      end
    end
  end
end
