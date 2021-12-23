# frozen_string_literal: true

describe Sentry::Gruf::ClientInterceptor do
  def run!
    interceptor_instance.call(request_context: request_context_stub, &callable)
  end

  subject(:interceptor_instance) { described_class.new }

  let(:request_context_stub) do
    instance_double(Gruf::Outbound::RequestContext).tap do |instance|
      allow(instance).to receive(:method_name).and_return("some_method")
      allow(instance).to receive(:route_key).and_return("some/route")
      allow(instance).to receive(:type).and_return("any_type")
    end
  end
  let(:callable) { proc { raise "Whoopsy" } }

  let(:expected_tags) do
    { grpc_method_name: "some_method", grpc_route_key: "some/route", grpc_call_type: "any_type" }
  end

  it "sets tags but doesn't report about error to the Sentry" do
    expect { run! }.to raise_error("Whoopsy")

    expect(Sentry.get_current_scope.tags.to_json).to be_json_as(expected_tags)
  end

  context "without raised error" do
    let(:callable) { proc { nil } }

    it "also sets Sentry tags" do
      run!

      expect(Sentry.get_current_scope.tags.to_json).to be_json_as(expected_tags)
    end
  end
end
