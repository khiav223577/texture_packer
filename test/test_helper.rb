require 'simplecov'
SimpleCov.start 'test_frameworks'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'texture_packer'
require 'minitest/autorun'
require 'mocha/minitest'
