# frozen_string_literal: true

require 'test_helper'
require 'texture_packer/cli'

class CliTest < Minitest::Test
  def setup
  end

  def test_v_flag
    cli = TexturePacker::Cli.new(['-v'])
    assert_output("#{TexturePacker::VERSION}\n"){ cli.run }
  end

  def test_verstion_floag
    cli = TexturePacker::Cli.new(['--version'])
    assert_output("#{TexturePacker::VERSION}\n"){ cli.run }
  end
end
