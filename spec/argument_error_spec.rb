RSpec.describe Superstructure::ArgumentError do
  let(:argument_error) do
    described_class.new(
      extra_params: extra_params,
      missing_params: missing_params,
      shadowed_params: shadowed_params
    )
  end

  describe "#message" do
    subject { argument_error.message }

    context "when there is only one type of error" do
      let(:extra_params) { ["alpha", :beta] }
      let(:missing_params) { [] }
      let(:shadowed_params) { [] }

      it "has a description of the error" do
        expect(subject).to eq 'Received unexpected options: ["alpha", :beta]'
      end
    end

    context "when there are multiple errors" do
      let(:extra_params) { [:elephant] }
      let(:missing_params) { [:mongoose] }
      let(:shadowed_params) { [:snake] }

      it "has a description of the all of the errors" do
        expect(subject).to include 'Received unexpected options: [:elephant]'
        expect(subject).to include 'Expected but did not receive: [:mongoose]'
        expect(subject).to include 'Received a symbol and string version of: [:snake]'
      end
    end
  end
end
