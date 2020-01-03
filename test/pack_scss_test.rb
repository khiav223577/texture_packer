# frozen_string_literal: true

require 'test_helper'

class PackScssTest < Minitest::Test
  def setup
  end

  def test_that_it_has_a_version_number
    refute_nil ::TexturePacker::VERSION
  end

  def test_pack_chest_ocean
    output_paths_mapping = { 'mobile' => 'packed_mobile', nil => 'packed' }
    content = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker 
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:d7446e3381d1c608ad889d49161494f4:d18632bf14c71b36ae676dd78a8e82e8:9669f0427628e775a1ba2129e70cffa5$
         ----------------------------------------------------
      
         usage: <span class="{-spritename-} sprite"></span>
      
         replace {-spritename-} with the sprite you like to use
      
      */
      
      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed.png);}
      
      .btn_boss {width:105px; height:99px; background-position: -108px -242px}
      .btn_boss:hover {width:105px; height:99px; background-position: -1px -242px}
      .btn_contest {width:105px; height:99px; background-position: -108px -343px}
      .btn_contest:hover {width:105px; height:99px; background-position: -1px -343px}
      .btn_craft {width:105px; height:99px; background-position: -108px -444px}
      .btn_craft:hover {width:105px; height:99px; background-position: -1px -444px}
      .btn_exercises {width:105px; height:99px; background-position: -108px -545px}
      .btn_exercises:hover {width:105px; height:99px; background-position: -1px -545px}
      .btn_index_in {width:69px; height:69px; background-position: -68px -747px}
      .btn_index_out {width:69px; height:69px; background-position: -139px -747px}
      .btn_mission {width:105px; height:99px; background-position: -108px -646px}
      .btn_mission:hover {width:105px; height:99px; background-position: -1px -646px}
      .icon_new {width:50px; height:50px; background-position: -97px -818px}
      .icon_redpoint {width:27px; height:27px; background-position: -1px -823px}
      .panel_bottom {width:65px; height:74px; background-position: -1px -747px}
      .panel_index_in {width:203px; height:239px; background-position: -1px -1px}
      .panel_min {width:65px; height:2px; background-position: -1px -852px}
      .panel_top {width:65px; height:20px; background-position: -30px -823px}
    STRING

    packer = TexturePacker.new('chest_ocean', output_paths_mapping, content, false)

    expected_output0 = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker 
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:d7446e3381d1c608ad889d49161494f4:d18632bf14c71b36ae676dd78a8e82e8:9669f0427628e775a1ba2129e70cffa5$
         ----------------------------------------------------
      
         usage: <span class="{-spritename-} sprite"></span>
      
         replace {-spritename-} with the sprite you like to use
      
      */
    STRING

    expected_output1 = <<~STRING
      @mixin chest_ocean_sprite_mobile{ background-image: image-url('chest_ocean_mobile.png'); }
      @mixin chest_ocean_sprite{ background-image: image-url('chest_ocean.png'); }
      @mixin chest_ocean_btn_boss{ width:105px; height:99px; background-position: -108px -242px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -242px; } }
      @mixin chest_ocean_btn_contest{ width:105px; height:99px; background-position: -108px -343px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -343px; } }
      @mixin chest_ocean_btn_craft{ width:105px; height:99px; background-position: -108px -444px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -444px; } }
      @mixin chest_ocean_btn_exercises{ width:105px; height:99px; background-position: -108px -545px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -545px; } }
      @mixin chest_ocean_btn_index_in{ width:69px; height:69px; background-position: -68px -747px; }
      @mixin chest_ocean_btn_index_out{ width:69px; height:69px; background-position: -139px -747px; }
      @mixin chest_ocean_btn_mission{ width:105px; height:99px; background-position: -108px -646px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -646px; } }
      @mixin chest_ocean_icon_new{ width:50px; height:50px; background-position: -97px -818px; }
      @mixin chest_ocean_icon_redpoint{ width:27px; height:27px; background-position: -1px -823px; }
      @mixin chest_ocean_panel_bottom{ width:65px; height:74px; background-position: -1px -747px; }
      @mixin chest_ocean_panel_index_in{ width:203px; height:239px; background-position: -1px -1px; }
      @mixin chest_ocean_panel_min{ width:65px; height:2px; background-position: -1px -852px; }
      @mixin chest_ocean_panel_top{ width:65px; height:20px; background-position: -30px -823px; }
    STRING

    expected_output2 = <<~STRING
      body[theme='ocean']{
        .chest_sprite{
          &[kind="mobile"] { @include chest_ocean_sprite_mobile; }
          @include chest_ocean_sprite;
          &.btn_boss { @include chest_ocean_btn_boss; }
          &.btn_contest { @include chest_ocean_btn_contest; }
          &.btn_craft { @include chest_ocean_btn_craft; }
          &.btn_exercises { @include chest_ocean_btn_exercises; }
          &.btn_index_in { @include chest_ocean_btn_index_in; }
          &.btn_index_out { @include chest_ocean_btn_index_out; }
          &.btn_mission { @include chest_ocean_btn_mission; }
          &.icon_new { @include chest_ocean_icon_new; }
          &.icon_redpoint { @include chest_ocean_icon_redpoint; }
          &.panel_bottom { @include chest_ocean_panel_bottom; }
          &.panel_index_in { @include chest_ocean_panel_index_in; }
          &.panel_min { @include chest_ocean_panel_min; }
          &.panel_top { @include chest_ocean_panel_top; }
        }
      }
    STRING

    output0, output1, output2 = packer.parse!
    assert_equal expected_output0, output0
    assert_equal expected_output1, output1
    assert_equal expected_output2, output2
  end
end
