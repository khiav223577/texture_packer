require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'texture_packer'

require 'minitest/autorun'

def expect_to_receive(obj, method, expected_args, return_value, &block)
  obj.stub(method, proc{|args|
    assert_equal(expected_args, args)
    next return_value
  }, &block)
end
