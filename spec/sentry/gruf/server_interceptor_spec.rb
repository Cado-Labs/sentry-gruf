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
  end

  context "without raised error" do
    let(:callable) { proc { nil } }

    it "doesn't send anything to Sentry" do
      expect(Sentry).not_to receive(:capture_exception)

      run!
    end
  end

  context "when sensitive_grpc_codes submitted" do
    subject(:result) do
      described_class.new(
        stubbed_request,
        error_object,
        {
          sensitive_grpc_codes: sensitive_grpc_codes,
        },
      )
    end

    let(:sensitive_grpc_codes) { %w[1 2] }

    context "when raised exception with code which is ignored" do
      let(:callable) { proc { raise GRPC::InvalidArgument.new } }

      it "raise exception but doesn't send anything to Sentry" do
        expect(Sentry).not_to receive(:capture_exception)

        expect { run! }.to raise_error(StandardError)
      end
    end

    context "when raised exception with code which is not ignored" do
      let(:sensitive_grpc_codes) { %w[3 16] }

      let(:callable) { proc { raise GRPC::InvalidArgument.new } }

      it "properly handles error" do
        expect(Sentry::Gruf).to receive(:capture_exception).and_call_original

        expect { run! }.to raise_error(StandardError)
      end
    end

    context "with empty sensitive_grpc_codes" do
      let(:sensitive_grpc_codes) { [] }
      let(:callable) { proc { raise GRPC::InvalidArgument.new } }

      it "raise exception but doesn't send anything to Sentry" do
        expect(Sentry).not_to receive(:capture_exception)

        expect { run! }.to raise_error(StandardError)
      end
    end
  end
end
