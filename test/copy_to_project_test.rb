# frozen_string_literal: true

require 'test_helper'

class CopyToProjectTest < Minitest::Test
  def setup
    @cli = TexturePacker::Cli.new(['-p', '/var/www/my_project'])

    output_paths_mapping = { nil => 'packed' }
    content = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker 
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:0e3cde37abc2d6283d832d64fcab33a3:c1d35c5361d7a9ec65c17d37456c5ef2:020bd24e3165ccf6122edbac54bb505b$
         ----------------------------------------------------
      
         usage: <span class="{-spritename-} sprite"></span>
      
         replace {-spritename-} with the sprite you like to use
      
      */
      
      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed.png);}
      
      .arrow-in {width:50px; height:98px; background-position: -1px -101px}
      .arrow-out {width:51px; height:98px; background-position: -1px -1px}
      .frame {width:73px; height:74px; background-position: -147px -80px}
      .icon_boss {width:71px; height:71px; background-position: -221px -1px}
      .icon_boss:hover {width:71px; height:71px; background-position: -148px -1px}
      .icon_contents {width:71px; height:71px; background-position: -294px -1px}
      .icon_contents:hover {width:71px; height:71px; background-position: -222px -74px}
      .icon_craft {width:57px; height:57px; background-position: -377px -74px}
      .icon_craft:hover {width:57px; height:57px; background-position: -172px -156px}
      .icon_mission {width:71px; height:71px; background-position: -295px -74px}
      .icon_mission:hover {width:71px; height:71px; background-position: -231px -147px}
      .panel_bottom {width:92px; height:77px; background-position: -53px -101px}
      .panel_top {width:92px; height:77px; background-position: -54px -1px}
      .shield {width:71px; height:71px; background-position: -304px -147px}
      .shield:hover {width:71px; height:71px; background-position: -367px -1px}
      .shine {width:53px; height:39px; background-position: -53px -180px}
      .sign_boss {width:30px; height:30px; background-position: -108px -180px}
      .sign_box {width:47px; height:47px; background-position: -377px -133px}
      .sign_mission {width:30px; height:30px; background-position: -140px -180px}
    STRING

    @packer = TexturePacker.new('side_menu_ocean', output_paths_mapping, content, false)
  end

  def test_save
    css_dir_path = Pathname.new('/var/www/my_project/app/assets/stylesheets/packed_sprites/side_menu')
    img_dir_path = Pathname.new('/var/www/my_project/app/assets/images')

    FileUtils.expects(:mkdir_p).with(css_dir_path)
    FileUtils.expects(:mkdir_p).with(img_dir_path)

    @cli.expects(:write_to_file).with(css_dir_path.join('mixin.scss'), 'content1')
    @cli.expects(:write_to_file).with(css_dir_path.join('ocean.scss'), "@import './mixin.scss';\n\ncontent2")
    FileUtils.expects(:cp).with('packed-fs8.png', img_dir_path.join('side_menu_ocean.png'))
    @cli.expects(:exec_cmd).with('pngquant', 'packed.png', '--force')

    @cli.send(:write_to_project_dir, @packer, 'content1', 'content2', false)
  end
end
