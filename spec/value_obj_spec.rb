RSpec.describe Superstructure::ValueObj do
  FooBar = Superstructure::ValueObj.new :foo, :bar
  Empty = Superstructure::ValueObj.new

  it "accepts parameters from symbol arguments and exposes them as methods" do
    foobar = FooBar.new(foo: 1, bar: 2)
    expect(foobar.foo).to eq 1
    expect(foobar.bar).to eq 2
  end

  it "accepts parameters from string arguments" do
    foobar = FooBar.new("foo" => "foo", "bar" => :bar)
    expect(foobar.foo).to eq "foo"
    expect(foobar.bar).to eq :bar
  end

  it "accepts parameters from a mix of string and symbol arguments" do
    foobar = FooBar.new("foo" => "foo", bar: :bar)
    expect(foobar.foo).to eq "foo"
    expect(foobar.bar).to eq :bar
  end

  it "exposes options in the to_hash method" do
    foobar = FooBar.new(foo: "foo?", bar: "bar?")
    expect(foobar.to_hash).to eq({
      foo: "foo?",
      bar: "bar?"
    })
  end

  it "exposes the parameters as readers" do
    expect(FooBar.instance_methods).to include :foo, :bar
  end

  it "does not expose writers" do
    foobar = FooBar.new(foo: :fruu, bar: :bruu)
    expect(foobar).not_to respond_to :foo=
    expect(foobar).not_to respond_to :bar=
  end

  describe "#inspect" do
    it "basic stuff" do
      foobar = FooBar.new(foo: 1, bar: 2)
      expect(foobar.inspect).to eq '#<value_obj FooBar foo=1, bar=2>'
    end

    it "handles complicated data structures" do
      foobar = FooBar.new(foo: [:a, :b], bar: 2)
      expect(foobar.inspect).to eq '#<value_obj FooBar foo=[:a, :b], bar=2>'
    end
  end

  it "can inherit from other classes" do
    superclass = Class.new
    subclass = Superstructure::ValueObj.new(:alpha, superclass: superclass)
    instance = subclass.new(alpha: "alpha")
    expect(instance).to be_kind_of superclass
  end

  it "can be passed additional methods" do
    klass = Superstructure::ValueObj.new(:alpha) do
      def hello
        "bonjour"
      end
    end

    instance = klass.new(alpha: "Alpharetta")
    expect(instance.hello).to eq "bonjour"
  end

  it "does not mutate the input" do
    opts = { foo: 42, bar: 24 }

    FooBar.new(opts)

    expect(opts[:foo]).to eq 42
    expect(opts[:bar]).to eq 24
  end

  describe "equality" do
    shared_examples_for "equality" do |operator|
      it "is equal if all arguments are equal" do
        alpha = FooBar.new(foo: 1, bar: 2)
        beta = FooBar.new("foo" => 1, "bar" => 2)
        expect(alpha.public_send(operator, beta)).to be_truthy
      end

      it "is not equal if any argument doesn't equal" do
        alpha = FooBar.new(foo: 1, bar: 2000)
        beta = FooBar.new("foo" => 1, "bar" => 2)
        expect(alpha.public_send(operator, beta)).to be_falsey
      end

      it "is equal only to other instances of the same class" do
        klass = Superstructure::ValueObj.new(:foo, :bar)
        opts = { foo: 42, bar: 24 }

        foobar = FooBar.new(opts)
        barfoo = klass.new(opts)

        expect(foobar.public_send(operator, barfoo)).to be_falsey
      end
    end

    describe "==" do
      it_behaves_like "equality", :==
    end

    describe "eql?" do
      it_behaves_like "equality", :eql?
    end
  end

  describe "error handling" do
    it "is an error to not pass all of the parameters" do
      expect { FooBar.new(foo: 1) }.to raise_error(Superstructure::ArgumentError) do |error|
        expect(error.missing_params).to eq [:bar]
        expect(error.extra_params).to be_empty
        expect(error.shadowed_params).to be_empty
      end
    end

    it "it an error to pass an extra parameter" do
      expect { Empty.new(baz: 3, lolcat: 4) }.to raise_error(Superstructure::ArgumentError) do |error|
        expect(error.missing_params).to be_empty
        expect(error.extra_params).to match [:baz, :lolcat]
        expect(error.shadowed_params).to be_empty
      end
    end

    it "is an error to pass a symbol and string version of the same paramter" do
      expect { FooBar.new(foo: 1, "foo" => 2, bar: 3) }.to raise_error(Superstructure::ArgumentError) do |error|
        expect(error.missing_params).to be_empty
        expect(error.extra_params).to be_empty
        expect(error.shadowed_params).to eq [:foo]
      end
    end

    it "does not create symbols for erroneous keys (as this could be a memory leak)" do
      expect do
        begin
          Empty.new("extra_symbol_1" => 1)
        rescue Superstructure::ArgumentError => e
          # noop
        end
      end.not_to change { Symbol.all_symbols.size }
    end
  end
end
