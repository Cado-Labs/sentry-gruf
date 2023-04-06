# frozen_string_literal: true

module Sentry
  module Gruf
    # Interceptor for Gruf wrapper of gRPC server.
    # It handles all uncaught exceptions and sent them to the Sentry.
    # Add this interceptor to the begining of interceptors stack.
    # @example Use server interceptor
    #   Gruf.configure do |config|
    #     config.interceptors.clear
    #     config.interceptors.use(Sentry::Gruf::ServerInterceptor)
    #   end
    class ServerInterceptor < ::Gruf::Interceptors::ServerInterceptor
      # Required method by Gruf interceptor specification.
      # @see https://rubydoc.info/gems/gruf/Gruf/Interceptors/ServerInterceptor Gruf documentation
      # @yield Perform request logic
      def call
        # make sure the current thread has a clean hub
        Sentry.clone_hub_to_current_thread

        Sentry.with_scope do |scope|
          scope.clear_breadcrumbs
          scope.set_transaction_name(request.service_key)
          scope.set_tags(
            grpc_method: request.method_key,
            grpc_request_class: request.request_class.name,
            grpc_service_key: request.service_key,
          )

          begin
            yield
          rescue Exception => e
            sensitive_grpc_codes = options[:sensitive_grpc_codes] || []
            raise if e.is_a?(GRPC::BadStatus) && sensitive_grpc_codes.exclude?(e.code.to_s)

            ::Sentry::Gruf.capture_exception(e)

            raise
          end
        end
      end
    end
  end
end
