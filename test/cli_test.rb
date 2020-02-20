# frozen_string_literal: true

require 'test_helper'
require 'texture_packer/cli'

class CliTest < Minitest::Test
  def setup
  end

  def test_v_flag
    expect_output(['-v'], "#{TexturePacker::VERSION}\n")
  end

  def test_verstion_flag
    expect_output(['--version'], "#{TexturePacker::VERSION}\n")
  end

  def test_h_flag
    expect_output(['-h'], <<~STRING)
    Usage: rake_test_loader [options]
        -v, --version                    show the version number
        -h, --help                       Prints this help
    STRING
  end

  def test_help_flag
    expect_output(['--help'], <<~STRING)
    Usage: rake_test_loader [options]
        -v, --version                    show the version number
        -h, --help                       Prints this help
    STRING
  end

  private

  def expect_output(args, output)
    cli = TexturePacker::Cli.new(args)
    assert_output(output){ cli.run }
  end
end
