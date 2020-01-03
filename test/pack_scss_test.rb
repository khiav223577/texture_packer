# frozen_string_literal: true

require 'test_helper'

class PackScssTest < Minitest::Test
  def setup
  end

  def test_that_it_has_a_version_number
    refute_nil ::TexturePacker::VERSION
  end
end
