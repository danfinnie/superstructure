require 'superstructure/value_obj'

RSpec.describe Superstructure::ValueObj do
  FooBar = Superstructure::ValueObj.new(:foo, :bar)

  it "accepts parameters from symbol arguments and exposes them as methods" do
    foobar = FooBar.new(foo: 1, bar: 2)
    expect(foobar.foo).to eq 1
    expect(foobar.bar).to eq 2
  end

  it "exposes the parameters as readers" do
    expect(FooBar.instance_methods).to include :foo, :bar
  end

  it "has inspect output similar to Struct" do
    foobar = FooBar.new(foo: 1, bar: 2)
    expect(foobar.inspect).to eq '#<value_obj FooBar foo=1, bar=2>'
  end
end
