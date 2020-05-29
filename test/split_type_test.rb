# frozen_string_literal: true

require 'test_helper'

class SplitTypeTest < Minitest::Test
  def setup
    @cli = TexturePacker::Cli.new(['-p', '/var/www/my_project'])
  end

  def test_i18n_and_mobile
    File.expects(:exist?).with('packed_tw_m.css').returns(true)
    assert_equal 'i18n_and_mobile', @cli.send(:calculate_split_type)
  end

  def test_mobile
    File.expects(:exist?).with('packed_tw_m.css').returns(false)
    File.expects(:exist?).with('packed_m.css').returns(true)
    assert_equal 'mobile', @cli.send(:calculate_split_type)
  end

  def test_i18n
    File.expects(:exist?).with('packed_tw_m.css').returns(false)
    File.expects(:exist?).with('packed_m.css').returns(false)
    File.expects(:exist?).with('packed_tw.css').returns(true)
    assert_equal 'i18n', @cli.send(:calculate_split_type)
  end

  def test_unknown
    File.expects(:exist?).with('packed_tw_m.css').returns(false)
    File.expects(:exist?).with('packed_m.css').returns(false)
    File.expects(:exist?).with('packed_tw.css').returns(false)
    assert_nil @cli.send(:calculate_split_type)
  end
end
