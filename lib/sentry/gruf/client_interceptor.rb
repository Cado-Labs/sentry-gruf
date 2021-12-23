# frozen_string_literal: true

module Sentry
  module Gruf
    # Interceptor for the Gruf client.
    # Please note that the interceptor itself does not send errors to Sentry.
    # It simply tags some information about the last request made through the client.
    # Just add this interceptor to the array of used interceptors as the first element.
    # @example Use client interceptor
    #   client = ::Gruf::Client.new(
    #     service: Some::Service,
    #     client_options: {
    #       interceptors: [Sentry::Gruf::ClientInterceptor.new, OtherInterceptors.new]
    #     }
    #   )
    class ClientInterceptor < ::Gruf::Interceptors::ClientInterceptor
      # @param request_context [Gruf::Outbound::RequestContext]
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
