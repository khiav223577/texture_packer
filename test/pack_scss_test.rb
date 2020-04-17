# frozen_string_literal: true

require 'test_helper'

class PackScssTest < Minitest::Test
  def setup
  end

  def test_that_it_has_a_version_number
    refute_nil ::TexturePacker::VERSION
  end

  def test_pack_without_mobile_version
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

    packer = TexturePacker.new('side_menu_ocean', output_paths_mapping, content)

    expected_output0 = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:0e3cde37abc2d6283d832d64fcab33a3:c1d35c5361d7a9ec65c17d37456c5ef2:020bd24e3165ccf6122edbac54bb505b$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */
    STRING

    expected_output1 = <<~STRING
      @mixin side_menu_ocean_sprite{ background-image: image-url('side_menu_ocean.png'); }
      @mixin side_menu_ocean_arrow{  &[in]{ width:50px; height:98px; background-position: -1px -101px; }&[out]{ width:51px; height:98px; background-position: -1px -1px; } }
      @mixin side_menu_ocean_frame{ width:73px; height:74px; background-position: -147px -80px; }
      @mixin side_menu_ocean_icon_boss{ width:71px; height:71px; background-position: -221px -1px; &:hover, &.hover{ width:71px; height:71px; background-position: -148px -1px; } }
      @mixin side_menu_ocean_icon_contents{ width:71px; height:71px; background-position: -294px -1px; &:hover, &.hover{ width:71px; height:71px; background-position: -222px -74px; } }
      @mixin side_menu_ocean_icon_craft{ width:57px; height:57px; background-position: -377px -74px; &:hover, &.hover{ width:57px; height:57px; background-position: -172px -156px; } }
      @mixin side_menu_ocean_icon_mission{ width:71px; height:71px; background-position: -295px -74px; &:hover, &.hover{ width:71px; height:71px; background-position: -231px -147px; } }
      @mixin side_menu_ocean_panel_bottom{ width:92px; height:77px; background-position: -53px -101px; }
      @mixin side_menu_ocean_panel_top{ width:92px; height:77px; background-position: -54px -1px; }
      @mixin side_menu_ocean_shield{ width:71px; height:71px; background-position: -304px -147px; &:hover, &.hover{ width:71px; height:71px; background-position: -367px -1px; } }
      @mixin side_menu_ocean_shine{ width:53px; height:39px; background-position: -53px -180px; }
      @mixin side_menu_ocean_sign_boss{ width:30px; height:30px; background-position: -108px -180px; }
      @mixin side_menu_ocean_sign_box{ width:47px; height:47px; background-position: -377px -133px; }
      @mixin side_menu_ocean_sign_mission{ width:30px; height:30px; background-position: -140px -180px; }
    STRING

    expected_output2 = <<~STRING
      body[theme='ocean']{
        .side_menu_sprite{
          @include side_menu_ocean_sprite;
          &.arrow { @include side_menu_ocean_arrow; }
          &.frame { @include side_menu_ocean_frame; }
          &.icon_boss { @include side_menu_ocean_icon_boss; }
          &.icon_contents { @include side_menu_ocean_icon_contents; }
          &.icon_craft { @include side_menu_ocean_icon_craft; }
          &.icon_mission { @include side_menu_ocean_icon_mission; }
          &.panel_bottom { @include side_menu_ocean_panel_bottom; }
          &.panel_top { @include side_menu_ocean_panel_top; }
          &.shield { @include side_menu_ocean_shield; }
          &.shine { @include side_menu_ocean_shine; }
          &.sign_boss { @include side_menu_ocean_sign_boss; }
          &.sign_box { @include side_menu_ocean_sign_box; }
          &.sign_mission { @include side_menu_ocean_sign_mission; }
        }
      }
    STRING

    output0, output1, output2 = packer.parse!
    assert_equal expected_output0, output0
    assert_equal expected_output1, output1
    assert_equal expected_output2, output2
  end

  def test_pack_with_images_with_lang_old_version # 向下相容
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

      .title_tw {width:50px; height:40px; background-position: -240px -280px}
      .title_cn {width:50px; height:40px; background-position: -240px -300px}
      .title_en {width:50px; height:40px; background-position: -240px -320px}
    STRING

    packer = TexturePacker.new('side_menu_ocean', output_paths_mapping, content)

    expected_output0 = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:0e3cde37abc2d6283d832d64fcab33a3:c1d35c5361d7a9ec65c17d37456c5ef2:020bd24e3165ccf6122edbac54bb505b$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */
    STRING

    expected_output1 = <<~STRING
      @mixin side_menu_ocean_sprite{ background-image: image-url('side_menu_ocean.png'); }
      @mixin side_menu_ocean_title_tw{ width:50px; height:40px; background-position: -240px -280px; }
      @mixin side_menu_ocean_title_cn{ width:50px; height:40px; background-position: -240px -300px; }
      @mixin side_menu_ocean_title_en{ width:50px; height:40px; background-position: -240px -320px; }
    STRING

    expected_output2 = <<~STRING
      body[theme='ocean']{
        .side_menu_sprite{
          @include side_menu_ocean_sprite;
          &.title:lang(zh-TW) { @include side_menu_ocean_title_tw; }
          &.title:lang(zh-CN) { @include side_menu_ocean_title_cn; }
          &.title:lang(en) { @include side_menu_ocean_title_en; }
        }
      }
    STRING

    output0, output1, output2 = packer.parse!
    assert_equal expected_output0, output0
    assert_equal expected_output1, output1
    assert_equal expected_output2, output2
  end

  def test_pack_with_images_with_lang
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

      .title-tw {width:50px; height:40px; background-position: -240px -280px}
      .title-cn {width:50px; height:40px; background-position: -240px -300px}
      .title-en {width:50px; height:40px; background-position: -240px -320px}
    STRING

    packer = TexturePacker.new('side_menu_ocean', output_paths_mapping, content)

    expected_output0 = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:0e3cde37abc2d6283d832d64fcab33a3:c1d35c5361d7a9ec65c17d37456c5ef2:020bd24e3165ccf6122edbac54bb505b$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */
    STRING

    expected_output1 = <<~STRING
      @mixin side_menu_ocean_sprite{ background-image: image-url('side_menu_ocean.png'); }
      @mixin side_menu_ocean_title{  &:lang(zh-TW){ width:50px; height:40px; background-position: -240px -280px; }&:lang(zh-CN){ width:50px; height:40px; background-position: -240px -300px; }&:lang(en){ width:50px; height:40px; background-position: -240px -320px; } }
    STRING

    expected_output2 = <<~STRING
      body[theme='ocean']{
        .side_menu_sprite{
          @include side_menu_ocean_sprite;
          &.title { @include side_menu_ocean_title; }
        }
      }
    STRING

    output0, output1, output2 = packer.parse!
    assert_equal expected_output0, output0
    assert_equal expected_output1, output1
    assert_equal expected_output2, output2
  end

  def test_pack_with_images_split_by_i18n
    output_paths_mapping = { 'tw' => 'packed_tw', 'cn' => 'packed_cn', 'en' => 'packed_en' }
    content = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:2cd54dfedabf543debe2795e2051379e:1a63a530863691503d3bf5b96866cada:ece2d26d0a976541d891f10f7c1a6c5e$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */

      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed_tw.png);}

      .exam-tw {width:151px; height:61px; background-position: -1px -1px}
      .official_beige-tw {width:151px; height:61px; background-position: -154px -1px}
      .official_blue-tw {width:151px; height:61px; background-position: -307px -1px}
      .player_beige-tw {width:151px; height:61px; background-position: -460px -1px}
      .player_blue-tw {width:151px; height:61px; background-position: -613px -1px}
      .video_beige-tw {width:151px; height:61px; background-position: -766px -1px}
      .video_blue-tw {width:151px; height:61px; background-position: -919px -1px}

      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:2cd54dfedabf543debe2795e2051379e:1a63a530863691503d3bf5b96866cada:ece2d26d0a976541d891f10f7c1a6c5e$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */

      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed_cn.png);}

      .exam-cn {width:151px; height:61px; background-position: -1px -1px}
      .official_beige-cn {width:151px; height:61px; background-position: -154px -1px}
      .official_blue-cn {width:151px; height:61px; background-position: -307px -1px}
      .player_beige-cn {width:151px; height:61px; background-position: -460px -1px}
      .player_blue-cn {width:151px; height:61px; background-position: -613px -1px}
      .video_beige-cn {width:151px; height:61px; background-position: -766px -1px}
      .video_blue-cn {width:151px; height:61px; background-position: -919px -1px}

      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:2cd54dfedabf543debe2795e2051379e:1a63a530863691503d3bf5b96866cada:ece2d26d0a976541d891f10f7c1a6c5e$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */

      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed_en.png);}

      .exam-en {width:151px; height:61px; background-position: -1px -1px}
      .official_beige-en {width:151px; height:61px; background-position: -154px -1px}
      .official_blue-en {width:151px; height:61px; background-position: -307px -1px}
      .player_beige-en {width:151px; height:61px; background-position: -460px -1px}
      .player_blue-en {width:151px; height:61px; background-position: -613px -1px}
      .video_beige-en {width:151px; height:61px; background-position: -766px -1px}
      .video_blue-en {width:151px; height:61px; background-position: -919px -1px}
    STRING

    packer = TexturePacker.new('explanation_words_ocean', output_paths_mapping, content, TexturePacker::SPLIT_BY_I18N)

    expected_output0 = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:2cd54dfedabf543debe2795e2051379e:1a63a530863691503d3bf5b96866cada:ece2d26d0a976541d891f10f7c1a6c5e$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */
    STRING

    expected_output1 = <<~STRING
      @mixin explanation_words_ocean_sprite_tw{ background-image: image-url('explanation_words_ocean_tw.png'); }
      @mixin explanation_words_ocean_sprite_cn{ background-image: image-url('explanation_words_ocean_cn.png'); }
      @mixin explanation_words_ocean_sprite_en{ background-image: image-url('explanation_words_ocean_en.png'); }
      @mixin explanation_words_ocean_exam{  &:lang(zh-TW){ width:151px; height:61px; background-position: -1px -1px; }&:lang(zh-CN){ width:151px; height:61px; background-position: -1px -1px; }&:lang(en){ width:151px; height:61px; background-position: -1px -1px; } }
      @mixin explanation_words_ocean_official_beige{  &:lang(zh-TW){ width:151px; height:61px; background-position: -154px -1px; }&:lang(zh-CN){ width:151px; height:61px; background-position: -154px -1px; }&:lang(en){ width:151px; height:61px; background-position: -154px -1px; } }
      @mixin explanation_words_ocean_official_blue{  &:lang(zh-TW){ width:151px; height:61px; background-position: -307px -1px; }&:lang(zh-CN){ width:151px; height:61px; background-position: -307px -1px; }&:lang(en){ width:151px; height:61px; background-position: -307px -1px; } }
      @mixin explanation_words_ocean_player_beige{  &:lang(zh-TW){ width:151px; height:61px; background-position: -460px -1px; }&:lang(zh-CN){ width:151px; height:61px; background-position: -460px -1px; }&:lang(en){ width:151px; height:61px; background-position: -460px -1px; } }
      @mixin explanation_words_ocean_player_blue{  &:lang(zh-TW){ width:151px; height:61px; background-position: -613px -1px; }&:lang(zh-CN){ width:151px; height:61px; background-position: -613px -1px; }&:lang(en){ width:151px; height:61px; background-position: -613px -1px; } }
      @mixin explanation_words_ocean_video_beige{  &:lang(zh-TW){ width:151px; height:61px; background-position: -766px -1px; }&:lang(zh-CN){ width:151px; height:61px; background-position: -766px -1px; }&:lang(en){ width:151px; height:61px; background-position: -766px -1px; } }
      @mixin explanation_words_ocean_video_blue{  &:lang(zh-TW){ width:151px; height:61px; background-position: -919px -1px; }&:lang(zh-CN){ width:151px; height:61px; background-position: -919px -1px; }&:lang(en){ width:151px; height:61px; background-position: -919px -1px; } }
    STRING

    expected_output2 = <<~STRING
      body[theme='ocean']{
        .explanation_words_sprite{
          &:lang(zh-TW){ @include explanation_words_ocean_sprite_tw; }
          &:lang(zh-CN){ @include explanation_words_ocean_sprite_cn; }
          &:lang(en){ @include explanation_words_ocean_sprite_en; }
          &.exam { @include explanation_words_ocean_exam; }
          &.official_beige { @include explanation_words_ocean_official_beige; }
          &.official_blue { @include explanation_words_ocean_official_blue; }
          &.player_beige { @include explanation_words_ocean_player_beige; }
          &.player_blue { @include explanation_words_ocean_player_blue; }
          &.video_beige { @include explanation_words_ocean_video_beige; }
          &.video_blue { @include explanation_words_ocean_video_blue; }
        }
      }
    STRING

    output0, output1, output2 = packer.parse!
    assert_equal expected_output0, output0
    assert_equal expected_output1, output1
    assert_equal expected_output2, output2
  end

  def test_pack_with_images_split_by_i18n_and_mobile
    output_paths_mapping = {
      'tw'   => 'packed_tw',
      'cn'   => 'packed_cn',
      'tw_m' => 'packed_tw_m',
      'cn_m' => 'packed_cn_m',
    }

    content = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:82fcb055ddeee0e6dbf5d1f69ebb4c69:c98b6be795491c5582285ea45c8901bd:d3a998f8a0a3d65c7be2f2d49f86c396$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */

      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed_tw.png);}

      .exam-tw {width:151px; height:61px; background-position: -1px -1px}
      .official_beige-tw {width:151px; height:61px; background-position: -154px -1px}
      .official_blue-tw {width:151px; height:61px; background-position: -307px -1px}
      .player_beige-tw {width:151px; height:61px; background-position: -460px -1px}
      .player_blue-tw {width:151px; height:61px; background-position: -613px -1px}
      .video_beige-tw {width:151px; height:61px; background-position: -766px -1px}
      .video_blue-tw {width:151px; height:61px; background-position: -919px -1px}

      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:82fcb055ddeee0e6dbf5d1f69ebb4c69:c98b6be795491c5582285ea45c8901bd:d3a998f8a0a3d65c7be2f2d49f86c396$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */

      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed_tw_m.png);}

      .official_beige-tw-m {width:101px; height:69px; background-position: -1px -1px}
      .official_blue-tw-m {width:101px; height:69px; background-position: -1px -72px}
      .player_beige-tw-m {width:101px; height:69px; background-position: -1px -143px}
      .player_blue-tw-m {width:101px; height:69px; background-position: -1px -214px}
      .video_beige-tw-m {width:101px; height:69px; background-position: -1px -285px}
      .video_blue-tw-m {width:101px; height:69px; background-position: -1px -356px}


      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:82fcb055ddeee0e6dbf5d1f69ebb4c69:c98b6be795491c5582285ea45c8901bd:d3a998f8a0a3d65c7be2f2d49f86c396$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */

      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed_cn.png);}

      .exam-cn {width:151px; height:61px; background-position: -1px -1px}
      .official_beige-cn {width:151px; height:61px; background-position: -154px -1px}
      .official_blue-cn {width:151px; height:61px; background-position: -307px -1px}
      .player_beige-cn {width:151px; height:61px; background-position: -460px -1px}
      .player_blue-cn {width:151px; height:61px; background-position: -613px -1px}
      .video_beige-cn {width:151px; height:61px; background-position: -766px -1px}
      .video_blue-cn {width:151px; height:61px; background-position: -919px -1px}

      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:82fcb055ddeee0e6dbf5d1f69ebb4c69:c98b6be795491c5582285ea45c8901bd:d3a998f8a0a3d65c7be2f2d49f86c396$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */

      .sprite {display:inline-block; overflow:hidden; background-repeat: no-repeat;background-image:url(packed_cn_m.png);}

      .official_beige-cn-m {width:101px; height:69px; background-position: -1px -1px}
      .official_blue-cn-m {width:101px; height:69px; background-position: -1px -72px}
      .player_beige-cn-m {width:101px; height:69px; background-position: -1px -143px}
      .player_blue-cn-m {width:101px; height:69px; background-position: -1px -214px}
      .video_beige-cn-m {width:101px; height:69px; background-position: -1px -285px}
      .video_blue-cn-m.png {width:101px; height:69px; background-position: -1px -356px}
    STRING

    split_type = TexturePacker::SPLIT_BY_I18N_AND_MOBILE
    packer = TexturePacker.new('explanation_words_ocean', output_paths_mapping, content, split_type)

    expected_output0 = <<~STRING
      /* ----------------------------------------------------
         created with http://www.codeandweb.com/texturepacker
         ----------------------------------------------------
         $TexturePacker:SmartUpdate:82fcb055ddeee0e6dbf5d1f69ebb4c69:c98b6be795491c5582285ea45c8901bd:d3a998f8a0a3d65c7be2f2d49f86c396$
         ----------------------------------------------------

         usage: <span class="{-spritename-} sprite"></span>

         replace {-spritename-} with the sprite you like to use

      */
    STRING

    expected_output1 = <<~STRING
      @mixin explanation_words_ocean_sprite_tw{ background-image: image-url('explanation_words_ocean_tw.png'); }
      @mixin explanation_words_ocean_sprite_cn{ background-image: image-url('explanation_words_ocean_cn.png'); }
      @mixin explanation_words_ocean_sprite_tw_m{ background-image: image-url('explanation_words_ocean_tw_m.png'); }
      @mixin explanation_words_ocean_sprite_cn_m{ background-image: image-url('explanation_words_ocean_cn_m.png'); }
      @mixin explanation_words_ocean_exam{  &:lang(zh-TW){ width:151px; height:61px; background-position: -1px -1px; }&:lang(zh-CN){ width:151px; height:61px; background-position: -1px -1px; } }
      @mixin explanation_words_ocean_official_beige{  &:lang(zh-TW){ width:151px; height:61px; background-position: -154px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -1px; } }&:lang(zh-CN){ width:151px; height:61px; background-position: -154px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -1px; } } }
      @mixin explanation_words_ocean_official_blue{  &:lang(zh-TW){ width:151px; height:61px; background-position: -307px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -72px; } }&:lang(zh-CN){ width:151px; height:61px; background-position: -307px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -72px; } } }
      @mixin explanation_words_ocean_player_beige{  &:lang(zh-TW){ width:151px; height:61px; background-position: -460px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -143px; } }&:lang(zh-CN){ width:151px; height:61px; background-position: -460px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -143px; } } }
      @mixin explanation_words_ocean_player_blue{  &:lang(zh-TW){ width:151px; height:61px; background-position: -613px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -214px; } }&:lang(zh-CN){ width:151px; height:61px; background-position: -613px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -214px; } } }
      @mixin explanation_words_ocean_video_beige{  &:lang(zh-TW){ width:151px; height:61px; background-position: -766px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -285px; } }&:lang(zh-CN){ width:151px; height:61px; background-position: -766px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -285px; } } }
      @mixin explanation_words_ocean_video_blue{  &:lang(zh-TW){ width:151px; height:61px; background-position: -919px -1px; @include mobile{ width:101px; height:69px; background-position: -1px -356px; } }&:lang(zh-CN){ width:151px; height:61px; background-position: -919px -1px; } }
    STRING

    expected_output2 = <<~STRING
      body[theme='ocean']{
        .explanation_words_sprite{
          @include desktop{
            &:lang(zh-TW){ @include explanation_words_ocean_sprite_tw; }
            &:lang(zh-CN){ @include explanation_words_ocean_sprite_cn; }
            &:lang(en){ @include explanation_words_ocean_sprite_en; }
          }
          @include mobile{
            &:lang(zh-TW){ @include explanation_words_ocean_sprite_tw_m; }
            &:lang(zh-CN){ @include explanation_words_ocean_sprite_cn_m; }
            &:lang(en){ @include explanation_words_ocean_sprite_en_m; }
          }
          &.exam { @include explanation_words_ocean_exam; }
          &.official_beige { @include explanation_words_ocean_official_beige; }
          &.official_blue { @include explanation_words_ocean_official_blue; }
          &.player_beige { @include explanation_words_ocean_player_beige; }
          &.player_blue { @include explanation_words_ocean_player_blue; }
          &.video_beige { @include explanation_words_ocean_video_beige; }
          &.video_blue { @include explanation_words_ocean_video_blue; }
        }
      }
    STRING

    output0, output1, output2 = packer.parse!

    assert_equal expected_output0, output0
    assert_equal expected_output1, output1
    assert_equal expected_output2, output2
  end
end
