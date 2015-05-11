require 'superstructure/value_obj'

RSpec.describe Superstructure::ValueObj do
  FooBar = Superstructure::ValueObj.new(:foo, :bar)

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

  it "has inspect output similar to Struct" do
    foobar = FooBar.new(foo: 1, bar: 2)
    expect(foobar.inspect).to eq '#<value_obj FooBar foo=1, bar=2>'
  end

  it "can inherit from other classes" do
    superclass = Class.new
    subclass = Superstructure::ValueObj.new(:alpha, superclass: superclass)
    instance = subclass.new(alpha: "alpha")
    expect(instance).to be_kind_of superclass
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
end
