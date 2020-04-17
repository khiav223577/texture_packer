# frozen_string_literal: true

require 'test_helper'

class PackScssMobileTest < Minitest::Test
  def setup
    @split_type = TexturePacker::SPLIT_BY_MOBILE
  end

  def test_pack
    output_paths_mapping = { 'm' => 'packed_m', nil => 'packed' }
    content = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:3fcd0ff116310d7ee86cae765341c09c:d18632bf14c71b36ae676dd78a8e82e8:9669f0427628e775a1ba2129e70cffa5$
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

      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:3fcd0ff116310d7ee86cae765341c09c:d18632bf14c71b36ae676dd78a8e82e8:9669f0427628e775a1ba2129e70cffa5$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */

      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed_mobile.png);}

      .btn_boss-hover-m {width:70px; height:66px; background-position: -140px -1px}
      .btn_boss-m {width:70px; height:66px; background-position: -140px -69px}
      .btn_contest-hover-m {width:70px; height:66px; background-position: -140px -137px}
      .btn_contest-m {width:70px; height:66px; background-position: -1px -163px}
      .btn_craft-hover-m {width:70px; height:66px; background-position: -212px -1px}
      .btn_craft-m {width:70px; height:66px; background-position: -212px -69px}
      .btn_exercises-hover-m {width:70px; height:66px; background-position: -212px -137px}
      .btn_exercises-m {width:70px; height:66px; background-position: -284px -1px}
      .btn_index_in-m {width:46px; height:46px; background-position: -119px -205px}
      .btn_index_out-m {width:46px; height:46px; background-position: -167px -205px}
      .btn_mission-hover-m {width:70px; height:66px; background-position: -284px -69px}
      .btn_mission-m {width:70px; height:66px; background-position: -284px -137px}
      .icon_new-m {width:33px; height:33px; background-position: -73px -214px}
      .icon_redpoint-m {width:18px; height:18px; background-position: -119px -163px}
      .panel_bottom-m {width:44px; height:49px; background-position: -73px -163px}
      .panel_index_in-m {width:137px; height:160px; background-position: -1px -1px}
      .panel_min-m {width:44px; height:1px; background-position: -1px -246px}
      .panel_top-m {width:44px; height:13px; background-position: -1px -231px}
    STRING

    packer = TexturePacker.new('chest_ocean', output_paths_mapping, content, @split_type)

    expected_output0 = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:3fcd0ff116310d7ee86cae765341c09c:d18632bf14c71b36ae676dd78a8e82e8:9669f0427628e775a1ba2129e70cffa5$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */
    STRING

    expected_output1 = <<~STRING
      @mixin chest_ocean_sprite_m{ background-image: image-url('chest_ocean_m.png'); }
      @mixin chest_ocean_sprite{ background-image: image-url('chest_ocean.png'); }
      @mixin chest_ocean_btn_boss{ width:105px; height:99px; background-position: -108px -242px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -242px; @include mobile{ width:70px; height:66px; background-position: -140px -1px; } }@include mobile{ width:70px; height:66px; background-position: -140px -69px; } }
      @mixin chest_ocean_btn_contest{ width:105px; height:99px; background-position: -108px -343px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -343px; @include mobile{ width:70px; height:66px; background-position: -140px -137px; } }@include mobile{ width:70px; height:66px; background-position: -1px -163px; } }
      @mixin chest_ocean_btn_craft{ width:105px; height:99px; background-position: -108px -444px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -444px; @include mobile{ width:70px; height:66px; background-position: -212px -1px; } }@include mobile{ width:70px; height:66px; background-position: -212px -69px; } }
      @mixin chest_ocean_btn_exercises{ width:105px; height:99px; background-position: -108px -545px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -545px; @include mobile{ width:70px; height:66px; background-position: -212px -137px; } }@include mobile{ width:70px; height:66px; background-position: -284px -1px; } }
      @mixin chest_ocean_btn_index_in{ width:69px; height:69px; background-position: -68px -747px; @include mobile{ width:46px; height:46px; background-position: -119px -205px; } }
      @mixin chest_ocean_btn_index_out{ width:69px; height:69px; background-position: -139px -747px; @include mobile{ width:46px; height:46px; background-position: -167px -205px; } }
      @mixin chest_ocean_btn_mission{ width:105px; height:99px; background-position: -108px -646px; &:hover, &.hover{ width:105px; height:99px; background-position: -1px -646px; @include mobile{ width:70px; height:66px; background-position: -284px -69px; } }@include mobile{ width:70px; height:66px; background-position: -284px -137px; } }
      @mixin chest_ocean_icon_new{ width:50px; height:50px; background-position: -97px -818px; @include mobile{ width:33px; height:33px; background-position: -73px -214px; } }
      @mixin chest_ocean_icon_redpoint{ width:27px; height:27px; background-position: -1px -823px; @include mobile{ width:18px; height:18px; background-position: -119px -163px; } }
      @mixin chest_ocean_panel_bottom{ width:65px; height:74px; background-position: -1px -747px; @include mobile{ width:44px; height:49px; background-position: -73px -163px; } }
      @mixin chest_ocean_panel_index_in{ width:203px; height:239px; background-position: -1px -1px; @include mobile{ width:137px; height:160px; background-position: -1px -1px; } }
      @mixin chest_ocean_panel_min{ width:65px; height:2px; background-position: -1px -852px; @include mobile{ width:44px; height:1px; background-position: -1px -246px; } }
      @mixin chest_ocean_panel_top{ width:65px; height:20px; background-position: -30px -823px; @include mobile{ width:44px; height:13px; background-position: -1px -231px; } }
    STRING

    expected_output2 = <<~STRING
      body[theme='ocean']{
        .chest_sprite{
          @include desktop{ @include chest_ocean_sprite; }
          @include mobile{ @include chest_ocean_sprite_m; }
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

  def test_pack_with_disabled_attributes

    output_paths_mapping = { 'm' => 'packed_m', nil => 'packed' }
    content = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker 
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:34ea7ee7d1f3145bef5a436293db74fe:8e5b46ee74783a269b7905a8f4cebce1:34c6c509e026266855d73b8f98e71a2d$
         ----------------------------------------------------
      
         usage: <span class="{-spritename-} sprite"></span>
      
         replace {-spritename-} with the sprite you like to use
      
      */
      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed.png);}

      .down_arrow {width:57px; height:57px; background-position: -585px -1px}
      .down_arrow:hover {width:57px; height:57px; background-position: -526px -1px}
      .down_arrow:active {width:57px; height:57px; background-position: -408px -1px}
      .down_arrow-disabled {width:57px; height:57px; background-position: -467px -1px}


      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed_m.png);}
     
      .down_arrow-active-hover-m {width:61px; height:61px; background-position: -127px -1px}
      .down_arrow-active-m {width:61px; height:61px; background-position: -127px -1px}
      .down_arrow-disabled-m {width:61px; height:61px; background-position: -190px -1px}
      .down_arrow-hover-m {width:61px; height:61px; background-position: -253px -1px}
      .down_arrow-m {width:61px; height:61px; background-position: -253px -1px}
    STRING

    packer = TexturePacker.new('reading_control_list_ocean', output_paths_mapping, content, @split_type)

    expected_output0 = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker 
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:34ea7ee7d1f3145bef5a436293db74fe:8e5b46ee74783a269b7905a8f4cebce1:34c6c509e026266855d73b8f98e71a2d$
         ----------------------------------------------------
      
         usage: <span class="{-spritename-} sprite"></span>
      
         replace {-spritename-} with the sprite you like to use
      
      */
    STRING

    expected_output1 = <<~STRING
      @mixin reading_control_list_ocean_sprite_m{ background-image: image-url('reading_control_list_ocean_m.png'); }
      @mixin reading_control_list_ocean_sprite{ background-image: image-url('reading_control_list_ocean.png'); }
      @mixin reading_control_list_ocean_down_arrow{ width:57px; height:57px; background-position: -585px -1px; &:hover, &.hover{ width:57px; height:57px; background-position: -526px -1px; @include mobile{ width:61px; height:61px; background-position: -253px -1px; } }&:active, &.active{ width:57px; height:57px; background-position: -408px -1px; &:hover, &.hover{  @include mobile{ width:61px; height:61px; background-position: -127px -1px; } }@include mobile{ width:61px; height:61px; background-position: -127px -1px; } }&:disabled, &.disabled{ width:57px; height:57px; background-position: -467px -1px; }&[disabled]{  @include mobile{ width:61px; height:61px; background-position: -190px -1px; } }@include mobile{ width:61px; height:61px; background-position: -253px -1px; } }
    STRING

    expected_output2 = <<~STRING
      body[theme='ocean']{
        .reading_control_list_sprite{
          @include desktop{ @include reading_control_list_ocean_sprite; }
          @include mobile{ @include reading_control_list_ocean_sprite_m; }
          &.down_arrow { @include reading_control_list_ocean_down_arrow; }
        }
      }
    STRING

    output0, output1, output2 = packer.parse!
    assert_equal expected_output0, output0
    assert_equal expected_output1, output1
    assert_equal expected_output2, output2
  end
end
