# frozen_string_literal: true

describe Sentry::Gruf::ServerInterceptor do
  def run!
    result.call(&callable)
  end

  subject(:result) { described_class.new(stubbed_request, error_object) }

  let(:stubbed_request) do
    instance_double(Gruf::Controllers::Request).tap do |instance|
      allow(instance).to receive(:method_key).and_return("method_key")
      allow(instance).to receive(:request_class).and_return(Object)
      allow(instance).to receive(:service_key).and_return("service_key")
    end
  end
  let(:error_object) { Gruf::Error.new }
  let(:callable) { proc { raise "Cheburek is not chelovek" } }

  let(:expected_tags) do
    { grpc_method: "method_key", grpc_request_class: "Object", grpc_service_key: "service_key" }
  end

  it "properly handles error" do
    expect(Sentry::Gruf).to receive(:capture_exception).and_call_original

    expect { run! }.to raise_error(StandardError)

    expect(Sentry.get_current_scope.transaction_name).to eq("service_key")
    expect(Sentry.get_current_scope.tags.to_json).to be_json_as(expected_tags)
  end

  context "without raised error" do
    let(:callable) { proc { nil } }

    it "doesn't send anything to Sentry" do
      expect(Sentry).not_to receive(:capture_exception)

      run!
    end
  end
end
