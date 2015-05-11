require 'superstructure/value_obj'

RSpec.describe Superstructure::ValueObj do
  FooBar = Superstructure::ValueObj.new(:foo, :bar)

  it "accepts parameters from symbol arguments and exposes them as methods" do
    foobar = FooBar.new(foo: 1, bar: 2)
    expect(foobar.foo).to eq 1
    expect(foobar.bar).to eq 2
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
end
