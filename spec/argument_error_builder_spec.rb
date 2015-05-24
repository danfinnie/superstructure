RSpec.describe Superstructure::ArgumentErrorBuilder do
  let(:builder) { described_class.new }

  describe "#error?" do
    subject { builder.error? }

    context "when at least one error has been added" do
      before do
        builder.add_error(:missing_params, :hello)
      end

      it { should be_truthy }
    end

    context "when no errors have been added" do
      it { should be_falsy }
    end
  end

  it "builds an ArgumentError with all of the added errors" do
    builder.add_error(:extra_params, :alpha)
    builder.add_errors(:missing_params, [:beta, :charlie])

    expect(builder.build).to have_attributes(
      extra_params: [:alpha],
      missing_params: [:beta, :charlie],
      shadowed_params: []
    )
  end
end
