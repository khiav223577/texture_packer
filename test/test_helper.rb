require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'texture_packer'

require 'minitest/autorun'
require 'mocha/minitest'
