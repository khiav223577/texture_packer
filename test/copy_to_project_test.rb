# frozen_string_literal: true

require 'test_helper'

class CopyToProjectTest < Minitest::Test
  def setup
    @cli = TexturePacker::Cli.new(['-p', '/var/www/my_project'])

    output_paths_mapping = { nil => 'packed' }
    content = 'fake_content'

    @packer = TexturePacker.new('side_menu_ocean', output_paths_mapping, content, false)
  end

  def test_save
    css_dir_path = Pathname.new('/var/www/my_project/app/assets/stylesheets/packed_sprites/side_menu')
    img_dir_path = Pathname.new('/var/www/my_project/app/assets/images')

    FileUtils.expects(:mkdir_p).with(css_dir_path)
    FileUtils.expects(:mkdir_p).with(img_dir_path)

    @cli.expects(:write_to_file).with(css_dir_path.join('mixin.scss'), 'fake_content1')
    @cli.expects(:write_to_file).with(css_dir_path.join('ocean.scss'), "@import './mixin.scss';\n\nfake_content2")
    FileUtils.expects(:cp).with('packed-fs8.png', img_dir_path.join('side_menu_ocean.png'))

    @cli.send(:write_to_project_dir, @packer, 'fake_content1', 'fake_content2', false)
  end
end
