# frozen_string_literal: true

require 'test_helper'

class CopyToProjectTest < Minitest::Test
  def setup
    @cli = TexturePacker::Cli.new(['-p', '/var/www/my_project'])

    output_paths_mapping = { nil => 'packed' }
    content = 'fake_content'

    @packer = TexturePacker.new('side_menu_ocean', output_paths_mapping, content)
  end

  def test_run_with_project_path
    @cli.expects(:pack_css!)
    @cli.expects(:create_packer).returns(@packer)
    @packer.expects(:parse!).returns(['fake_output1', 'fake_output2', 'fake_output3'])
    @cli.expects(:compress_images!)
    @cli.expects(:write_to_file).with('packed.scss', 'fake_output1fake_output2fake_output3')

    mock_write_to_project_dir

    @cli.run
  end

  def test_write_to_project_dir_method
    mock_write_to_project_dir
    @cli.send(:write_to_project_dir!, @packer, 'fake_output2', 'fake_output3')
  end

  private

  def mock_write_to_project_dir
    css_dir_path = Pathname.new('/var/www/my_project/app/assets/stylesheets/packed_sprites/side_menu')
    img_dir_path = Pathname.new('/var/www/my_project/app/assets/images')

    FileUtils.expects(:mkdir_p).with(css_dir_path)
    FileUtils.expects(:mkdir_p).with(img_dir_path)

    @cli.expects(:write_to_file).with(css_dir_path.join('mixin.scss'), 'fake_output2')
    @cli.expects(:write_to_file).with(css_dir_path.join('ocean.scss'), "@import './mixin.scss';\n\nfake_output3")
    FileUtils.expects(:cp).with('packed-fs8.png', img_dir_path.join('side_menu_ocean.png'))
  end
end
